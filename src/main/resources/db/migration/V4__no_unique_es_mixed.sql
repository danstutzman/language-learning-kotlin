ALTER TABLE leafs ADD COLUMN infinitive_leaf_id INTEGER REFERENCES leafs (leaf_id);

UPDATE leafs SET infinitive_leaf_id = (
  SELECT leaf_id FROM leafs AS leafs2 WHERE leafs2.es_mixed = leafs.infinitive_es_mixed
);

ALTER TABLE leafs DROP CONSTRAINT fk_leafs_leafs_es_mixed;

ALTER TABLE leafs DROP COLUMN infinitive_es_mixed;

DROP INDEX idx_leafs_es_mixed;
CREATE INDEX idx_leafs_es_mixed
  ON leafs(es_mixed);

DROP INDEX idx_leafs_es_lower;
