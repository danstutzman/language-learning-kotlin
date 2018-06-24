CREATE TABLE unique_conjugations (
  unique_conjugation_id SERIAL PRIMARY KEY,
  es                    TEXT NOT NULL,
  en                    TEXT NOT NULL,
  infinitive_es         TEXT NOT NULL REFERENCES infinitives(es),
  number                INTEGER NOT NULL,
  person                INTEGER NOT NULL,
  tense                 TEXT NOT NULL,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_unique_conjugations_es ON unique_conjugations(es);
