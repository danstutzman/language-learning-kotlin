CREATE SEQUENCE leaf_ids;

CREATE TABLE nonverbs (
  leaf_id           INTEGER PRIMARY KEY,
  es                TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  en_plural         TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_nonverbs_es ON nonverbs(es);
CREATE UNIQUE INDEX idx_nonverbs_en_and_en_disambiguation ON nonverbs(en, en_disambiguation);
CREATE UNIQUE INDEX idx_nonverbs_en_plural_and_en_disambiguation ON nonverbs(en_plural, en_disambiguation);

CREATE TABLE infinitives (
  leaf_id           INTEGER PRIMARY KEY,
  es                TEXT NOT NULL,
  en                TEXT NOT NULL,
  en_past           TEXT NOT NULL,
  en_disambiguation TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_infinitives_es ON infinitives(es);
CREATE UNIQUE INDEX idx_infinitives_en_and_en_disambiguation ON infinitives(en, en_disambiguation);
CREATE UNIQUE INDEX idx_infinitives_en_past_and_en_disambiguation ON infinitives(en_past, en_disambiguation);

CREATE TABLE unique_conjugations (
  leaf_id       INTEGER PRIMARY KEY,
  es            TEXT NOT NULL,
  en            TEXT NOT NULL,
  infinitive_es TEXT NOT NULL REFERENCES infinitives(es),
  number        INTEGER NOT NULL,
  person        INTEGER NOT NULL,
  tense         TEXT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_unique_conjugations_es ON unique_conjugations(es);

CREATE TABLE stem_changes (
  leaf_id        INTEGER PRIMARY KEY,
  infinitive_es  TEXT NOT NULL REFERENCES infinitives(es),
  stem           TEXT NOT NULL,
  tense          TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_stem_changes_stem ON stem_changes(stem);
