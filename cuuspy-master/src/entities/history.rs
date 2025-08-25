use chrono::prelude::*;
use serde::Deserialize;
pub struct History {
  pub id: i64,
  pub user_id: i64,
  pub manga_id: i64,
  pub manga_name: String,
  pub manga_cover_url: String,
  pub chapter_id: i64,
  pub chapter_number: String,
  pub chapter_name: String,
  pub read_pages: i64,
  pub total_pages: i64,
  pub created_at: DateTime<Utc>,
  pub updated_at: DateTime<Utc>,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct PendingCommitHistory {
  pub user_id: i64,
  pub manga_id: i64,
  pub manga_name: String,
  pub manga_cover_url: String,
  pub chapter_id: i64,
  pub chapter_number: String,
  pub chapter_name: String,
  pub read_pages: i64,
  pub total_pages: i64,
}
