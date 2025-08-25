use anyhow::Result;
use axum::{
  extract::{Query, State},
  http:: StatusCode,
  Json,
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use crate::entities::history::{History, PendingCommitHistory};
use crate::errors::ApiError;
use crate::repositories::history_repository::{get_by_chapter, get_by_manga, get_by_user};
use crate::AppState;
use axum_macros::debug_handler;

#[derive(Deserialize)]
pub struct HistoriesQueryParams {
  user_id: i64,
  manga_id: Option<i64>,
  chapter_id: Option<i64>,
  cursor: Option<String>,
  limit: Option<usize>,
}

#[derive(Serialize)]
pub struct HistoryResponse {
  manga_id: i64,
  manga_name: String,
  manga_cover_url: String,
  chapter_id: i64,
  chapter_number: String,
  chapter_name: String,
  read_pages: i64,
  total_pages: i64,
  created_at: String,
  updated_at: String,
}

#[derive(Serialize)]
pub struct PaginatedResponse<T> {
    data: Vec<T>,
    next_cursor: Option<String>,
}

pub async fn index(
  Query(params): Query<HistoriesQueryParams>,
  State(state): State<Arc<AppState>>
) -> Result<Json<PaginatedResponse<HistoryResponse>>, ApiError> {
  let user_id = params.user_id;

  let histories = match params.manga_id {
    Some(manga_id) => {
      match params.chapter_id {
        Some(chapter_id) => {
          let mut conn = state.pool.get()?;
          get_by_chapter(user_id, manga_id, chapter_id, &mut conn)?
        }
        None => {
          let mut conn = state.pool.get()?;
          get_by_manga(user_id, manga_id, &mut conn)?
        }
      }
    },
    None => {
      let mut conn = state.pool.get()?;
      let (histories, new_cursor) = get_by_user(user_id, &mut conn, params.cursor.as_deref(), params.limit.unwrap_or(20))?;
      return Ok(Json(PaginatedResponse {
        data: create_response(histories),
        next_cursor: new_cursor,
      }));
    }
  };

  Ok(Json(PaginatedResponse {
    data: create_response(histories),
    next_cursor: None,
  }))
}

#[debug_handler]
pub async fn create(
  State(state): State<Arc<AppState>>,
  Json(history): Json<PendingCommitHistory>
) -> Result<StatusCode, ApiError> {
  {
    let mut batch = state.pending_commit_histories.lock().await;
    batch.push(history);
  }
  Ok(StatusCode::CREATED)
}

fn create_response(histories: Vec<History>) -> Vec<HistoryResponse> {
  histories.iter().map(
    |history| {
      HistoryResponse {
        manga_id: history.manga_id,
        manga_name: history.manga_name.to_owned(),
        manga_cover_url: history.manga_cover_url.to_owned(),
        chapter_id: history.chapter_id,
        chapter_number: history.chapter_number.to_owned(),
        chapter_name: history.chapter_name.to_owned(),
        read_pages: history.read_pages,
        total_pages: history.total_pages,
        created_at: history.created_at.to_rfc3339(),
        updated_at: history.updated_at.to_rfc3339(),
      }
    }
  ).collect()
}
