CREATE TABLE stem_changes (
  stem_change_id SERIAL PRIMARY KEY,
  infinitive_es  TEXT NOT NULL REFERENCES infinitives(es),
  stem           TEXT NOT NULL,
  tense          TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_stem_changes_stem ON stem_changes(stem);
