ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV',
    'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange', 'ArNonverb', 'ArVRoot'));

ALTER TABLE leafs DROP CONSTRAINT leafs_ar_buckwalter_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_buckwalter_check
  CHECK ((leaf_type IN ('ArNonverb', 'ArVRoot')
    AND ar_buckwalter IS NOT NULL) OR
  (leaf_type NOT IN ('ArNonverb', 'ArVRoot')
    AND ar_buckwalter IS NULL));

ALTER TABLE leafs ADD COLUMN ar_pres_middle_vowel_buckwalter TEXT;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_pres_middle_vowel_buckwalter_check
  CHECK ((leaf_type IN ('ArVRoot')
    AND ar_pres_middle_vowel_buckwalter IN ('a', 'i', 'u')) OR
  (leaf_type NOT IN ('ArVRoot')
    AND ar_pres_middle_vowel_buckwalter IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_en_past_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_en_past_check
  CHECK ((leaf_type IN ('EsInf', 'EsStemChange', 'FrInf', 'FrStemChange',
    'ArVRoot') AND en_past IS NOT NULL) OR
  (leaf_type NOT IN ('EsInf', 'EsStemChange', 'FrInf', 'FrStemChange',
    'ArVRoot') AND en_past IS NULL));
