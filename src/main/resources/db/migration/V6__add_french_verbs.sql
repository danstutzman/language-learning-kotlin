ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV', 'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange'));

ALTER TABLE leafs ADD CONSTRAINT leafs_fr_mixed_check
  CHECK ((leaf_type IN ('FrInf', 'FrUniqV', 'FrNonverb', 'FrStemChange')
    AND fr_mixed IS NOT NULL) OR
  (leaf_type NOT IN ('FrInf', 'FrUniqV', 'FrNonverb', 'FrStemChange')
    AND fr_mixed IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_en_past_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_en_past_check
  CHECK ((leaf_type IN ('EsInf', 'EsStemChange', 'FrInf', 'FrStemChange')
    AND en_past IS NOT NULL) OR
  (leaf_type NOT IN ('EsInf', 'EsStemChange', 'FrInf', 'FrStemChange')
    AND en_past IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_infinitive_leaf_id_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_infinitive_leaf_id_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange')
    AND infinitive_leaf_id IS NOT NULL) OR
  (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange')
    AND infinitive_leaf_id IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_number_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_number_check
  CHECK ((leaf_type IN ('EsUniqV', 'FrUniqV') AND number IN (1, 2)) OR
    (leaf_type NOT IN ('EsUniqV', 'FrUniqV') AND number IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_person_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_person_check
  CHECK ((leaf_type IN ('EsUniqV', 'FrUniqV') AND person IN (1, 2, 3)) OR
    (leaf_type NOT IN ('EsUniqV', 'FrUniqV') AND person IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_tense_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_tense_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange') AND tense IN ('PRES', 'PRET')) OR
    (leaf_type IN ('FrUniqV', 'FrStemChange') AND tense IN ('PRES')) OR
    (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange') AND person IS NULL));
