CREATE TABLE leafs (
  leaf_id             SERIAL PRIMARY KEY,
  leaf_type           TEXT NOT NULL CHECK (leaf_type IN ('Inf', 'Nonverb', 'StemChange', 'UniqV')),
  es_mixed            TEXT NOT NULL,
  en                  TEXT NOT NULL,
  en_disambiguation   TEXT NOT NULL,
  en_plural           TEXT,
  en_past             TEXT CHECK (NOT (leaf_type = 'Inf' AND en_past IS NULL)),
  infinitive_es_mixed TEXT CHECK (NOT (leaf_type IN ('StemChange', 'UniqV') AND infinitive_es_mixed IS NULL)),
  number              INTEGER CHECK (NOT (leaf_type = 'UniqV' AND number IS NULL)),
  person              INTEGER CHECK (NOT (leaf_type = 'UniqV' AND person IS NULL)),
  tense               TEXT CHECK (NOT (leaf_type IN ('StemChange', 'UniqV') AND tense NOT IN ('PRES', 'PRET'))),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_leafs_es_lower
  ON leafs(LOWER(es_mixed));
CREATE UNIQUE INDEX idx_leafs_es_mixed
  ON leafs(es_mixed);

ALTER TABLE leafs ADD CONSTRAINT fk_leafs_leafs_es_mixed
  FOREIGN KEY (infinitive_es_mixed)
  REFERENCES leafs (es_mixed);

CREATE UNIQUE INDEX idx_leafs_nonverbs_en_and_en_disambiguation
  ON leafs(en, en_disambiguation)
  WHERE leaf_type = 'Nonverb';
CREATE UNIQUE INDEX idx_leafs_nonverbs_en_plural_and_en_disambiguation
  ON leafs(en_plural, en_disambiguation)
  WHERE leaf_type = 'Nonverb';

CREATE UNIQUE INDEX idx_leafs_infinitives_en_and_en_disambiguation
  ON leafs(en, en_disambiguation)
  WHERE leaf_type = 'Inf';
CREATE UNIQUE INDEX idx_leafs_infinitives_en_past_and_en_disambiguation
  ON leafs(en_past, en_disambiguation)
  WHERE leaf_type = 'Inf';
