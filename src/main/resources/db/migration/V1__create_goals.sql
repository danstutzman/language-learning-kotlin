CREATE TABLE goals (
  goal_id           SERIAL PRIMARY KEY,
  tags              TEXT NOT NULL,
  en_free_text      TEXT NOT NULL,
  es                TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL
);
