use axum::{
  http:: header::CONTENT_TYPE,
  Router,
  routing::{get, post},
};
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use repositories::history_repository::add_one_tx;
use std::sync::Arc;
use std::sync::atomic::{AtomicI64, Ordering};
use dashmap::DashMap;
use db::init_db;
use tower_http:: cors::{Any, CorsLayer};
use tokio::signal;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
use tokio::sync::Mutex;
use entities::history::PendingCommitHistory;
use anyhow::Result;
use serde_json::json;

pub mod db;
pub mod routes;
pub mod errors;
pub mod repositories;
pub mod entities;

pub struct AppState {
  pool: Pool<SqliteConnectionManager>,
  pending_commit_histories: Mutex<Vec<PendingCommitHistory>>,
  chapter_views: DashMap<i64, AtomicI64>, // (chapter_id, views_count_delta) - lock-free!
}

async fn commit_histories(state: &Arc<AppState>, batch: Vec<PendingCommitHistory>) -> Result<()> {
  let mut conn = state.pool.get()?;
  let mut tx = conn.transaction()?;

  for record in batch {
    add_one_tx(
      record.user_id,
      record.manga_id,
      &record.manga_name,
      &record.manga_cover_url,
      record.chapter_id,
      &record.chapter_number,
      &record.chapter_name,
      record.read_pages,
      record.total_pages,
      &mut tx,
    )?;
  }

  tx.commit()?;
  Ok(())
}

async fn commit_chapter_views(views_data: Vec<(i64, i64)>) -> Result<()> {
  let client = reqwest::Client::new();
  let payload = json!({
    "views": views_data.iter().map(|(chapter_id, views_count_delta)| {
      json!({
        "chapter_id": chapter_id,
        "views_count_delta": views_count_delta
      })
    }).collect::<Vec<_>>()
  });

  let response = client
    .post("http://cuutruyen_api:3000/api/v2/commit_views")
    .json(&payload)
    .send()
    .await?;

  if response.status().is_success() {
    Ok(())
  } else {
    anyhow::bail!("failed to commit chapter views: {}", response.status())
  }
}

pub async fn process_pending_commit_histories(state: Arc<AppState>) {
  loop {
    tokio::time::sleep(tokio::time::Duration::from_secs(10)).await;  // Adjust as needed
    let records_to_insert = {
      let mut batch = state.pending_commit_histories.lock().await;
      std::mem::take(&mut *batch)
    };
    if !records_to_insert.is_empty() {
      let state_clone = state.clone();
      tokio::spawn(async move {
        let records_count = records_to_insert.len();

        match commit_histories(&state_clone, records_to_insert).await {
            Ok(_) => {
                tracing::info!(message = "successfully committed histories", records_count = records_count);
            },
            Err(e) => {
                tracing::error!(message = "error committing histories", error = e.to_string(), records_count = records_count);
            }
        }
      });
    }
  }
}

pub async fn process_chapter_views(state: Arc<AppState>) {
  loop {
    tokio::time::sleep(tokio::time::Duration::from_secs(20 * 60)).await; // 20 minutes

    let views_to_commit = {
      let mut views_data = Vec::new();
      let mut keys_to_remove = Vec::new();

      // Iterate through all chapter views
      for entry in state.chapter_views.iter() {
        let chapter_id = *entry.key();
        let views_count_delta = entry.value().load(Ordering::Relaxed);

        if views_count_delta > 100 {
          views_data.push((chapter_id, views_count_delta));
          keys_to_remove.push(chapter_id);
        }
      }

      // Remove committed entries
      for key in keys_to_remove {
        state.chapter_views.remove(&key);
      }

      views_data
    };

    if !views_to_commit.is_empty() {
      // Create a compact string format of chapter_id=views_count
      let views_data_string = views_to_commit.iter()
        .map(|(chapter_id, views_count)| format!("{chapter_id}={views_count}"))
        .collect::<Vec<_>>()
        .join(", ");
      
      tracing::info!(message = "chapter views count data about to commit", views_data = views_data_string);
      
      tokio::spawn(async move {
        let chapters_count = views_to_commit.len();
        match commit_chapter_views(views_to_commit).await {
          Ok(_) => {
            tracing::info!(message = "successfully committed chapter views", chapters_count = chapters_count);
          },
          Err(e) => {
            tracing::error!(message = "error committing chapter views", error = e.to_string(), chapters_count = chapters_count);
          }
        }
      });
    }
  }
}

#[tokio::main]
async fn main() {
  tracing_subscriber::registry()
    .with(
      tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| {
        // axum logs rejections from built-in extractors with the `axum::rejection`
        // target, at `TRACE` level. `axum::rejection=trace` enables showing those events
        "cuuspy=debug,tower_http=debug,axum::rejection=trace".into()
      }),
    )
    .with(tracing_subscriber::fmt::layer())
    .init();

  let database_path = std::env::var("DATABASE_PATH")
    .expect("DATABASE_PATH environment variable is not set").into();

  let pool = init_db(&database_path).expect("Cannot initialize connection to SQLite database!");

  let state = Arc::new(
    AppState {
      pool,
      pending_commit_histories: Mutex::new(vec![]),
      chapter_views: DashMap::new(),
    }
  );

  tokio::spawn(process_pending_commit_histories(state.clone()));
  tokio::spawn(process_chapter_views(state.clone()));

  let api_routes = Router::new()
    .route("/histories", get(routes::histories::index).post(routes::histories::create))
    .route("/views/:chapter_id", post(routes::chapter_views::record_view));

  let app = Router::new()
    .nest("/api", api_routes)
    .with_state(state)
    .layer(
      CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers([CONTENT_TYPE])
    );

  let listener = tokio::net::TcpListener::bind("0.0.0.0:3001").await.unwrap();
  println!("Server is listening on {}!", listener.local_addr().unwrap());
  axum::serve(listener, app)
    .with_graceful_shutdown(shutdown_signal())
    .await
    .unwrap();
}

async fn shutdown_signal() {
    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("failed to install signal handler")
            .recv()
            .await;
    };

    tokio::select! {
        _ = ctrl_c => {},
        _ = terminate => {},
    }
}
