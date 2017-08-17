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

DO
$do$
DECLARE
	m   varchar[];
	arr varchar[] := array[
    ['10','M','libro','book'],
    ['20','F','pluma','pen']
  ];
BEGIN
	FOREACH m SLICE 1 IN ARRAY arr
	LOOP
		INSERT INTO actions (
			action_id,
			type,
			created_at_millis,
			synced_at,
			card_json
		) VALUES (
			CAST(m[1] AS INT),
			'ADD_CARD',
			EXTRACT(EPOCH FROM NOW()) * 1000,
			NOW(),
			'{"type":"EsN",' ||
      ' "gender":"' || m[2] || '",' ||
      ' "es":"' || m[3] || '",' ||
      ' "en":"' || m[4] || '"}'
		);
   END LOOP;
END
$do$
