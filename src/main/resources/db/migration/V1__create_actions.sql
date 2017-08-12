CREATE TABLE actions (
  action_id              INT NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (action_id)
);
CREATE UNIQUE INDEX idx_actions_action_id on actions(action_id);
