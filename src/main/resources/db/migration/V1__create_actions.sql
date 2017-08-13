CREATE TABLE actions (
  action_id  INT NOT NULL,
  type       TEXT NOT NULL,
  synced_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (action_id)
);

CREATE UNIQUE INDEX idx_actions_action_id on actions(action_id);

INSERT INTO actions VALUES (10, 'ADD_CARD');
