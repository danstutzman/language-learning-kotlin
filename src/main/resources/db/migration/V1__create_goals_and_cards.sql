CREATE TABLE goals (
  goal_id           SERIAL PRIMARY KEY,
  en                TEXT NOT NULL,
  es                TEXT NOT NULL,
  leaf_ids_csv      TEXT NOT NULL,
  paragraph_id      INTEGER NOT NULL REFERENCES paragraphs(paragraph_id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL
);

CREATE TABLE cards (
  card_id           SERIAL PRIMARY KEY,
  gloss_rows_json   TEXT NOT NULL,
  last_seen_at      TIMESTAMPTZ,
  leaf_ids_csv      TEXT NOT NULL,
  prompt            TEXT NOT NULL,
  stage             INTEGER NOT NULL,
  mnemonic          TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX idx_cards_leaf_ids_csv ON cards(leaf_ids_csv);

CREATE TABLE paragraphs (
  paragraph_id      SERIAL PRIMARY KEY,
  topic             TEXT NOT NULL,
  enabled           BOOLEAN NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL
);
