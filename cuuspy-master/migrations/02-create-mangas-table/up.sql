CREATE TABLE mangas (
  id INTEGER PRIMARY KEY,
  manga_name TEXT,
  manga_cover_url TEXT,
  created_at DATETIME,
  updated_at DATETIME
);

CREATE UNIQUE INDEX idx_mangas_manga_id ON mangas (id);
