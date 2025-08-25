use axum::{
    extract::{Path, State},
    http::StatusCode,
};
use std::sync::Arc;
use std::sync::atomic::{AtomicI64, Ordering};
use crate::AppState;
use crate::errors::ApiError;

pub async fn record_view(
    Path(chapter_id): Path<i64>,
    State(state): State<Arc<AppState>>,
) -> Result<StatusCode, ApiError> {
    // Lock-free atomic increment using DashMap + AtomicI64
    state.chapter_views
        .entry(chapter_id)
        .or_insert_with(|| AtomicI64::new(0))
        .fetch_add(1, Ordering::Relaxed);
    
    tracing::debug!("Recorded view for chapter_id: {}", chapter_id);
    Ok(StatusCode::OK)
}
