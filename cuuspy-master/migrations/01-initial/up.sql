CREATE TABLE histories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  manga_id INTEGER,
  manga_name TEXT,
  manga_cover_url TEXT,
  chapter_id INTEGER,
  chapter_number TEXT,
  chapter_name TEXT,
  read_pages INTEGER,
  total_pages INTEGER,
  created_at DATETIME,
  updated_at DATETIME,
  UNIQUE(user_id, manga_id, chapter_id)
);

CREATE INDEX idx_histories_created_at ON histories (created_at);
CREATE INDEX idx_histories_updated_at ON histories (updated_at);

-- CREATE TABLE manga_views (
--   id INTEGER PRIMARY KEY AUTOINCREMENT,
--   manga_id INTEGER,
--   views_count INTEGER,
--   created_at DATETIME,
--   updated_at DATETIME,
--   UNIQUE(manga_id)
-- );

-- CREATE TABLE chapter_views (
--   id INTEGER PRIMARY KEY AUTOINCREMENT,
--   manga_id INTEGER,
--   chapter_id INTEGER,
--   views_count INTEGER,
--   created_at DATETIME,
--   updated_at DATETIME,
--   UNIQUE(manga_id, chapter_id)
-- );

-- CREATE TABLE team_views (
--   id INTEGER PRIMARY KEY AUTOINCREMENT,
--   team_id INTEGER,
--   views_count INTEGER,
--   created_at DATETIME,
--   updated_at DATETIME,
--   UNIQUE(team_id)
-- );
