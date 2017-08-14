CREATE TABLE actions (
  action_id         INT NOT NULL,
  type              TEXT NOT NULL,
  created_at_millis BIGINT NOT NULL,
  synced_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (action_id)
);

CREATE UNIQUE INDEX idx_actions_action_id on actions(action_id);

CREATE UNIQUE INDEX idx_actions_created_at_millis on actions(created_at_millis);

INSERT INTO actions VALUES (10, 'ADD_CARD', EXTRACT(EPOCH FROM NOW()) * 1000);
