CREATE TABLE morphemes (
  id    SERIAL PRIMARY KEY,
  lang  TEXT NOT NULL,
  type  TEXT NOT NULL,
  l2    TEXT NOT NULL,
  gloss TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE new_cards (
  id               SERIAL PRIMARY KEY,
  lang             TEXT NOT NULL,
  type             TEXT NOT NULL,
  en_task          TEXT,
  en_content       TEXT,
  morpheme_ids_csv TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
