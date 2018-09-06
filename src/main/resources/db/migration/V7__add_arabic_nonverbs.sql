ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV', 'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange', 'ArNonverb'));

ALTER TABLE leafs ADD COLUMN ar_buckwalter TEXT;

ALTER TABLE leafs ADD CONSTRAINT leafs_ar_buckwalter_check
  CHECK ((leaf_type IN ('ArNonverb') AND ar_buckwalter IS NOT NULL) OR
    (leaf_type NOT IN ('ArNonverb') AND ar_buckwalter IS NULL));
