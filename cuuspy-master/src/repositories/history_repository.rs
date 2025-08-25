use rusqlite::{Connection, Transaction, params};
use anyhow::Result;
use indoc::indoc;
use crate::entities::history::History;
use chrono::{DateTime, Utc};
use base64::prelude::*;
use std::str;

pub fn get_by_user(user_id: i64, conn: &mut Connection, cursor: Option<&str>, limit: usize) -> Result<(Vec<History>, Option<String>)> {
  // Decode the base64 cursor to a UNIX timestamp
  let cursor_timestamp = cursor
    .and_then(|c| BASE64_STANDARD.decode(c).ok())
    .and_then(|d| String::from_utf8(d).ok()) // Convert Vec<u8> to String
    .and_then(|s| s.parse::<i64>().ok())
    .map_or(Utc::now().timestamp(), |ts| ts);

  // Convert the UNIX timestamp to a DateTime<Utc> object
  let cursor_datetime: DateTime<Utc> = DateTime::from_timestamp(cursor_timestamp, 0).unwrap_or(Utc::now());

    let query = indoc! {"
        SELECT
            h.id,
            h.user_id,
            h.manga_id,
            COALESCE(m.manga_name, '') as manga_name,
            COALESCE(m.manga_cover_url, '') as manga_cover_url,
            h.chapter_id,
            h.chapter_number,
            h.chapter_name,
            h.read_pages,
            h.total_pages,
            h.created_at,
            h.updated_at
        FROM
            histories h
        LEFT JOIN
            mangas m ON h.manga_id = m.id
        WHERE
            h.user_id = ?
            AND h.updated_at < ?
        ORDER BY
            h.updated_at DESC
        LIMIT ?
    "};

    let mut statement = conn.prepare(query)?;
    let mut rows = statement.query((user_id, &cursor_datetime, limit + 1))?;
    let mut histories: Vec<History> = Vec::new();
    let mut has_more = false;

    while let Some(row) = rows.next()? {
        if histories.len() == limit {
            has_more = true;
            break;
        }

        let history = History {
            id: row.get("id")?,
            user_id: row.get("user_id")?,
            manga_id: row.get("manga_id")?,
            manga_name: row.get::<_, Option<String>>("manga_name")?.unwrap_or_default(),
            manga_cover_url: row.get::<_, Option<String>>("manga_cover_url")?.unwrap_or_default(),
            chapter_id: row.get("chapter_id")?,
            chapter_number: row.get("chapter_number")?,
            chapter_name: row.get("chapter_name")?,
            read_pages: row.get("read_pages")?,
            total_pages: row.get("total_pages")?,
            created_at: row.get("created_at")?,
            updated_at: row.get("updated_at")?,
        };

        histories.push(history);
    }

    // Set the new cursor based on whether there's more data to fetch
    let new_cursor = if has_more {
        histories.last().map(|history| BASE64_STANDARD.encode(&history.updated_at.timestamp().to_string()))
    } else {
        None
    };

    Ok((histories, new_cursor))
}

pub fn get_by_manga(user_id: i64, manga_id: i64, conn: &mut Connection) -> Result<Vec<History>> {
  let query = indoc! {"
    SELECT
      h.id,
      h.user_id,
      h.manga_id,
      COALESCE(m.manga_name, '') as manga_name,
      COALESCE(m.manga_cover_url, '') as manga_cover_url,
      h.chapter_id,
      h.chapter_number,
      h.chapter_name,
      h.read_pages,
      h.total_pages,
      h.created_at,
      h.updated_at
    FROM
      histories h
    LEFT JOIN
      mangas m ON h.manga_id = m.id
    WHERE
      h.user_id = ?
      AND h.manga_id = ?
  "};
  let mut statement = conn.prepare(query)?;
  let mut rows = statement.query((user_id, manga_id))?;
  let mut histories: Vec<History> = Vec::new();

  while let Some(row) = rows.next()? {
    let history = History {
        id: row.get("id")?,
        user_id: row.get("user_id")?,
        manga_id: row.get("manga_id")?,
        manga_name: row.get::<_, Option<String>>("manga_name")?.unwrap_or_default(),
        manga_cover_url: row.get::<_, Option<String>>("manga_cover_url")?.unwrap_or_default(),
        chapter_id: row.get("chapter_id")?,
        chapter_number: row.get("chapter_number")?,
        chapter_name: row.get("chapter_name")?,
        read_pages: row.get("read_pages")?,
        total_pages: row.get("total_pages")?,
        created_at: row.get("created_at")?,
        updated_at: row.get("updated_at")?,
    };

    histories.push(history);
  }

  Ok(histories)
}

pub fn get_by_chapter(user_id: i64, manga_id: i64, chapter_id: i64, conn: &mut Connection) -> Result<Vec<History>> {
  let query = indoc! {"
    SELECT
      h.id,
      h.user_id,
      h.manga_id,
      COALESCE(m.manga_name, '') as manga_name,
      COALESCE(m.manga_cover_url, '') as manga_cover_url,
      h.chapter_id,
      h.chapter_number,
      h.chapter_name,
      h.read_pages,
      h.total_pages,
      h.created_at,
      h.updated_at
    FROM
      histories h
    LEFT JOIN
      mangas m ON h.manga_id = m.id
    WHERE
      h.user_id = ?
      AND h.manga_id = ?
      AND h.chapter_id = ?
  "};
  let mut statement = conn.prepare(query)?;
  let mut rows = statement.query((user_id, manga_id, chapter_id))?;
  let mut histories: Vec<History> = Vec::new();

  while let Some(row) = rows.next()? {
    let history = History {
        id: row.get("id")?,
        user_id: row.get("user_id")?,
        manga_id: row.get("manga_id")?,
        manga_name: row.get::<_, Option<String>>("manga_name")?.unwrap_or_default(),
        manga_cover_url: row.get::<_, Option<String>>("manga_cover_url")?.unwrap_or_default(),
        chapter_id: row.get("chapter_id")?,
        chapter_number: row.get("chapter_number")?,
        chapter_name: row.get("chapter_name")?,
        read_pages: row.get("read_pages")?,
        total_pages: row.get("total_pages")?,
        created_at: row.get("created_at")?,
        updated_at: row.get("updated_at")?,
    };

    histories.push(history);
  }

  Ok(histories)
}

pub fn add_one(
  user_id: i64,
  manga_id: i64,
  manga_name: &str,
  manga_cover_url: &str,
  chapter_id: i64,
  chapter_number: &str,
  chapter_name: &str,
  read_pages: i64,
  total_pages: i64,
  conn: &mut Connection
) -> Result<i64> {
  let now = Utc::now();

  // First, insert or update the manga record
  let manga_query = indoc! {"
    INSERT INTO mangas (
      id, manga_name, manga_cover_url, created_at, updated_at
    )
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      manga_name = excluded.manga_name,
      manga_cover_url = excluded.manga_cover_url,
      updated_at = excluded.updated_at
  "};

  conn.execute(
    manga_query,
    params![manga_id, manga_name, manga_cover_url, now, now]
  )?;

  // Then, insert or update the history record
  let history_query = indoc! {"
    INSERT INTO histories (
      user_id, manga_id, chapter_id, chapter_number,
      chapter_name, read_pages, total_pages, created_at, updated_at
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(user_id, manga_id, chapter_id) DO UPDATE SET
      read_pages = MAX(read_pages, excluded.read_pages),
      total_pages = excluded.total_pages,
      updated_at = excluded.updated_at
    RETURNING id
  "};

  let row_id = conn.query_row(
    history_query,
    params![
      user_id, manga_id, chapter_id, chapter_number,
      chapter_name, read_pages, total_pages, now, now
    ],
    |row| row.get(0)
  )?;

  Ok(row_id)
}

pub fn add_one_tx(
  user_id: i64,
  manga_id: i64,
  manga_name: &str,
  manga_cover_url: &str,
  chapter_id: i64,
  chapter_number: &str,
  chapter_name: &str,
  read_pages: i64,
  total_pages: i64,
  tx: &Transaction
) -> Result<i64> {
  let now = Utc::now();

  // First, insert or update the manga record
  let manga_query = indoc! {"
    INSERT INTO mangas (
      id, manga_name, manga_cover_url, created_at, updated_at
    )
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      manga_name = excluded.manga_name,
      manga_cover_url = excluded.manga_cover_url,
      updated_at = excluded.updated_at
  "};

  tx.execute(
    manga_query,
    params![manga_id, manga_name, manga_cover_url, now, now]
  )?;

  // Then, insert or update the history record
  let history_query = indoc! {"
    INSERT INTO histories (
      user_id, manga_id, chapter_id, chapter_number,
      chapter_name, read_pages, total_pages, created_at, updated_at
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(user_id, manga_id, chapter_id) DO UPDATE SET
      read_pages = MAX(read_pages, excluded.read_pages),
      total_pages = excluded.total_pages,
      updated_at = excluded.updated_at
    RETURNING id
  "};

  let row_id = tx.query_row(
    history_query,
    params![
      user_id, manga_id, chapter_id, chapter_number,
      chapter_name, read_pages, total_pages, now, now
    ],
    |row| row.get(0)
  )?;

  Ok(row_id)
}
