ALTER TABLE leafs DROP CONSTRAINT leafs_leaf_type_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_leaf_type_check
  CHECK (leaf_type IN ('EsInf', 'EsNonverb', 'EsStemChange', 'EsUniqV',
    'FrNonverb', 'FrInf', 'FrUniqV', 'FrStemChange', 'ArNonverb', 'ArVRoot',
    'ArStemChange', 'ArUniqV', 'ArNoun'));

ALTER TABLE leafs DROP CONSTRAINT leafs_ar_buckwalter_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_ar_buckwalter_check
  CHECK ((leaf_type IN ('ArNonverb', 'ArVRoot', 'ArStemChange', 'ArUniqV',
    'ArNoun') AND ar_buckwalter IS NOT NULL) OR
  (leaf_type NOT IN ('ArNonverb', 'ArVRoot', 'ArStemChange', 'ArUniqV',
    'ArNoun') AND ar_buckwalter IS NULL));

ALTER TABLE leafs DROP CONSTRAINT leafs_gender_check;
ALTER TABLE leafs ADD CONSTRAINT leafs_gender_check
  CHECK ((leaf_type IN ('ArUniqV') AND gender IN ('', 'M', 'F')) OR
     (leaf_type IN ('ArNoun') AND gender IN ('M', 'F')) OR
     (leaf_type NOT IN ('ArUniqV', 'ArNoun') AND gender IS NULL));
