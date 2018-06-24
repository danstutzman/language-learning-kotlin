CREATE TABLE infinitives (
  infinitive_id     SERIAL PRIMARY KEY,
  es                TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_past           TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_infinitives_es ON infinitives(es);
CREATE UNIQUE INDEX idx_infinitives_en_and_en_disambiguation ON infinitives(en, en_disambiguation);
CREATE UNIQUE INDEX idx_infinitives_en_past_and_en_disambiguation ON infinitives(en_past, en_disambiguation);
