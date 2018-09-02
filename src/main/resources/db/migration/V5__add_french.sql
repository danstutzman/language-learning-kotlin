UPDATE cards SET gloss_rows_json = REPLACE(gloss_rows_json, '"es":', '"l2":');

ALTER TABLE paragraphs ADD COLUMN lang TEXT;
UPDATE paragraphs SET lang = 'es';
ALTER TABLE paragraphs ALTER COLUMN lang SET NOT NULL;

ALTER TABLE leafs ALTER COLUMN es_mixed DROP NOT NULL;

ALTER TABLE leafs ADD COLUMN fr_mixed TEXT;
CREATE UNIQUE INDEX idx_leafs_fr_mixed
  ON leafs(fr_mixed);

DROP INDEX idx_leafs_nonverbs_en_and_en_disambiguation;
DROP INDEX idx_leafs_nonverbs_en_plural_and_en_disambiguation;
DROP INDEX idx_leafs_infinitives_en_and_en_disambiguation;
DROP INDEX idx_leafs_infinitives_en_past_and_en_disambiguation;

ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
UPDATE leafs SET leaf_type = 'EsInf' WHERE leaf_type = 'Inf';
UPDATE leafs SET leaf_type = 'EsNonverb' WHERE leaf_type = 'Nonverb';
UPDATE leafs SET leaf_type = 'EsStemChange' WHERE leaf_type = 'StemChange';
UPDATE leafs SET leaf_type = 'EsUniqV' WHERE leaf_type = 'UniqV';
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV', 'FrNonverb'));

ALTER TABLE leafs DROP CONSTRAINT leafs_check;
ALTER TABLE leafs DROP CONSTRAINT leafs_check2;
ALTER TABLE leafs DROP CONSTRAINT leafs_check3;
ALTER TABLE leafs DROP CONSTRAINT leafs_check4;

ALTER TABLE leafs ADD CONSTRAINT leafs_es_mixed_check
  CHECK ((leaf_type IN ('EsInf', 'EsStemChange', 'EsUniqV', 'EsNonverb')
      AND es_mixed IS NOT NULL) OR
    (leaf_type NOT IN ('EsInf', 'EsStemChange', 'EsUniqV', 'EsNonverb')
      AND es_mixed IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_en_past_check
  CHECK ((leaf_type IN ('EsInf', 'EsStemChange') AND en_past IS NOT NULL) OR
    (leaf_type NOT IN ('EsInf', 'EsStemChange') AND en_past IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_en_plural_check
  CHECK ((leaf_type IN ('EsNonverb')) OR
    (leaf_type NOT IN ('EsNonverb') AND en_plural IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_infinitive_leaf_id_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange') AND infinitive_leaf_id IS NOT NULL) OR
    (leaf_type NOT IN ('EsUniqV', 'EsStemChange') AND infinitive_leaf_id IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_number_check
  CHECK ((leaf_type IN ('EsUniqV') AND number IN (1, 2)) OR
    (leaf_type NOT IN ('EsUniqV') AND number IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_person_check
  CHECK ((leaf_type IN ('EsUniqV') AND person IN (1, 2, 3)) OR
    (leaf_type NOT IN ('EsUniqV') AND person IS NULL));

ALTER TABLE leafs ADD CONSTRAINT leafs_tense_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange') AND tense IN ('PRES', 'PRET')) OR
    (leaf_type NOT IN ('EsUniqV', 'EsStemChange') AND person IS NULL));

ALTER TABLE leafs ALTER COLUMN en_disambiguation DROP NOT NULL;
ALTER TABLE leafs ADD CONSTRAINT leafs_en_disambiguation_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange', 'EsNonverb', 'EsInf')
      AND en_disambiguation IS NOT NULL) OR
    (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'EsNonverb', 'EsInf')
      AND en_disambiguation IS NULL));

ALTER TABLE goals RENAME COLUMN es TO l2;
