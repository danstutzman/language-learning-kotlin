ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV',
    'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange', 'ArNonverb', 'ArVRoot',
    'ArStemChange', 'ArUniqV'));

ALTER TABLE leafs DROP CONSTRAINT leafs_ar_buckwalter_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_buckwalter_check
  CHECK ((leaf_type IN ('ArNonverb', 'ArVRoot', 'ArStemChange', 'ArUniqV')
    AND ar_buckwalter IS NOT NULL) OR
  (leaf_type NOT IN ('ArNonverb', 'ArVRoot', 'ArStemChange', 'ArUniqV')
    AND ar_buckwalter IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_infinitive_leaf_id_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_infinitive_leaf_id_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange',
		'ArStemChange', 'ArUniqV') AND infinitive_leaf_id IS NOT NULL) OR
  (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange',
		'ArStemChange', 'ArUniqV') AND infinitive_leaf_id IS NULL));

ALTER TABLE leafs ADD COLUMN gender TEXT;
ALTER TABLE leafs ADD CONSTRAINT leafs_gender_check
  CHECK ((leaf_type IN ('ArUniqV') AND gender IN ('', 'M', 'F')) OR
 (leaf_type NOT IN ('ArUniqV') AND gender IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_number_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_number_check
  CHECK ((leaf_type IN ('EsUniqV', 'FrUniqV', 'ArUniqV')
    AND number IN (1, 2)) OR
    (leaf_type NOT IN ('EsUniqV', 'FrUniqV', 'ArUniqV') AND number IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_person_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_person_check
  CHECK ((leaf_type IN ('EsUniqV', 'FrUniqV', 'ArUniqV')
    AND person IN (1, 2, 3)) OR
    (leaf_type NOT IN ('EsUniqV', 'FrUniqV', 'ArUniqV') AND person IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_tense_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_tense_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange')
    AND tense IN ('PRES', 'PRET')) OR
  (leaf_type IN ('FrUniqV', 'FrStemChange') AND tense IN ('PRES')) OR
  (leaf_type IN ('ArStemChange', 'ArUniqV') AND tense IN ('PAST', 'PRES')) OR
  (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange',
    'ArStemChange', 'ArUniqV') AND tense IS NULL));
