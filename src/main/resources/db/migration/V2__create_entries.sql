CREATE TABLE entries (
  entry_id          SERIAL PRIMARY KEY,
  es                TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  en_plural         TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_entries_es ON entries(es);
CREATE UNIQUE INDEX idx_entries_en_and_en_disambiguation ON entries(en, en_disambiguation);
CREATE UNIQUE INDEX idx_entries_en_plural_and_en_disambiguation ON entries(en_plural, en_disambiguation);
