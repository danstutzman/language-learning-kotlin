ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV',
    'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange', 'ArNonverb', 'ArVRoot',
    'ArStemChange'));

ALTER TABLE leafs DROP CONSTRAINT leafs_ar_buckwalter_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_buckwalter_check
  CHECK ((leaf_type IN ('ArNonverb', 'ArVRoot', 'ArStemChange')
    AND ar_buckwalter IS NOT NULL) OR
  (leaf_type NOT IN ('ArNonverb', 'ArVRoot', 'ArStemChange')
    AND ar_buckwalter IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_infinitive_leaf_id_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_infinitive_leaf_id_check
  CHECK ((leaf_type IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange',
		'ArStemChange') AND infinitive_leaf_id IS NOT NULL) OR
  (leaf_type NOT IN ('EsUniqV', 'EsStemChange', 'FrUniqV', 'FrStemChange',
		'ArStemChange') AND infinitive_leaf_id IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_ar_pres_middle_vowel_buckwalter_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_pres_middle_vowel_buckwalter_check
  CHECK ((leaf_type IN ('ArVRoot')
    AND ar_pres_middle_vowel_buckwalter IN ('a', 'i', 'u', 'o', '?')) OR
 (leaf_type NOT IN ('ArVRoot') AND ar_pres_middle_vowel_buckwalter IS NULL));

ALTER TABLE leafs ADD COLUMN persons_csv TEXT;
ALTER TABLE leafs ADD CONSTRAINT leafs_persons_csv_check
  CHECK ((leaf_type IN ('ArStemChange')
    AND persons_csv IN ('1,2', '3', '1,2,3')) OR
 (leaf_type NOT IN ('ArStemChange') AND persons_csv IS NULL));
