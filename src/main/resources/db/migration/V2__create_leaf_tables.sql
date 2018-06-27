CREATE SEQUENCE leaf_ids;

CREATE TABLE nonverbs (
  leaf_id           INTEGER PRIMARY KEY,
  es_mixed          TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  en_plural         TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_nonverbs_es_lower ON nonverbs(LOWER(es_mixed));
CREATE UNIQUE INDEX idx_nonverbs_en_and_en_disambiguation ON nonverbs(en, en_disambiguation);
CREATE UNIQUE INDEX idx_nonverbs_en_plural_and_en_disambiguation ON nonverbs(en_plural, en_disambiguation);

CREATE TABLE infinitives (
  leaf_id           INTEGER PRIMARY KEY,
  es_mixed          TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_past           TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_infinitives_es_mixed ON infinitives(es_mixed);
CREATE UNIQUE INDEX idx_infinitives_es_lower ON infinitives(LOWER(es_mixed));
CREATE UNIQUE INDEX idx_infinitives_en_and_en_disambiguation ON infinitives(en, en_disambiguation);
CREATE UNIQUE INDEX idx_infinitives_en_past_and_en_disambiguation ON infinitives(en_past, en_disambiguation);

CREATE TABLE unique_conjugations (
  leaf_id             INTEGER PRIMARY KEY,
  es_mixed            TEXT NOT NULL,
  en                  TEXT NOT NULL,
  infinitive_es_mixed TEXT NOT NULL REFERENCES infinitives(es_mixed),
  number              INTEGER NOT NULL,
  person              INTEGER NOT NULL,
  tense               TEXT NOT NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_unique_conjugations_es_mixed ON unique_conjugations(LOWER(es_mixed));

CREATE TABLE stem_changes (
  leaf_id              INTEGER PRIMARY KEY,
  infinitive_es_mixed  TEXT NOT NULL REFERENCES infinitives(es),
  stem_mixed           TEXT NOT NULL,
  tense                TEXT NOT NULL,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_stem_changes_stem_lower ON stem_changes(LOWER(stem_mixed));
