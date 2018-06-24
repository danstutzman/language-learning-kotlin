CREATE TABLE nonverbs (
  nonverb_id        SERIAL PRIMARY KEY,
  es                TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  en_plural         TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_nonverbs_es ON nonverbs(es);
CREATE UNIQUE INDEX idx_nonverbs_en_and_en_disambiguation ON nonverbs(en, en_disambiguation);
CREATE UNIQUE INDEX idx_nonverbs_en_plural_and_en_disambiguation ON nonverbs(en_plural, en_disambiguation);
