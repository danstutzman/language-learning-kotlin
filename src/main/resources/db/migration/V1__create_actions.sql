CREATE TABLE actions (
  action_id         INT NOT NULL,
  type              TEXT NOT NULL,
  created_at_millis BIGINT NOT NULL,
  synced_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  card_json         TEXT,
  exposure_json     TEXT,
  PRIMARY KEY (action_id)
);

CREATE UNIQUE INDEX idx_actions_action_id on actions(action_id);

CREATE INDEX idx_actions_created_at_millis on actions(created_at_millis);

INSERT INTO actions (
  action_id,
  type,
  created_at_millis,
  synced_at,
  card_json
) VALUES (
  10,
  'ADD_CARD',
  EXTRACT(EPOCH FROM NOW()) * 1000,
  NOW(),
  '{"type":"EsN", "gender":"M", "es":"libro", "en":"book"}'
);

INSERT INTO actions (
  action_id,
  type,
  created_at_millis,
  synced_at,
  card_json
) VALUES (
  20,
  'ADD_CARD',
  EXTRACT(EPOCH FROM NOW()) * 1000,
  NOW(),
  '{"type":"EsN", "gender":"F", "es":"pluma", "en":"pen"}'
);
