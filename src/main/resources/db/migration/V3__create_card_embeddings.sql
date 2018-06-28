CREATE TABLE card_embeddings (
  card_embedding_id   SERIAL PRIMARY KEY,
  longer_card_id      INTEGER NOT NULL REFERENCES cards(card_id),
  shorter_card_id     INTEGER NOT NULL REFERENCES cards(card_id),
  first_leaf_index    INTEGER NOT NULL,
  last_leaf_index     INTEGER NOT NULL
);

CREATE UNIQUE INDEX idx_card_embeddings
  ON card_embeddings(longer_card_id, shorter_card_id);
