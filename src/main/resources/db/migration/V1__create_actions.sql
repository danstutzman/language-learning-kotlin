CREATE TABLE actions (
  action_id         INT NOT NULL,
  type              TEXT NOT NULL,
  created_at_millis BIGINT NOT NULL,
  synced_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  card_json         TEXT,
  card_id           INT,
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
    ['skin','piel','F']
  , ['arm','brazo','M']
  , ['leg','pierna','F']
  , ['heart','corazón','M']
  , ['stomach','estómago','M']
  , ['eye','ojo','M']
  , ['nose','nariz','F']
  , ['mouth','boca','F']
  , ['ear','oreja','F']
  , ['face','cara','F']
  , ['neck','cuello','M']
  , ['finger','dedo','M']
  , ['foot','pie','M']
  , ['thigh','muslo','M']
  , ['ankle','tobillo','M']
  , ['elbow','codo','M']
  , ['wrist','muñeca','F']
  , ['buttocks','nalgas','F']
  , ['body','cuerpo','M']
  , ['hair','pelo','M']
  , ['tooth','diente','M']
  , ['hand','mano','F']
  , ['back','espalda','F']
  , ['hip','cadera','F']
  , ['jaw','mandibula','F']
  , ['hombro','shoulder','M']
  , ['thumb','pulgar','M']
  , ['tongue','lengua','F']
  , ['throat','garganta','F']
  ];
DECLARE
  action_id int8 := 10;
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
      action_id,
			'ADD_CARD',
			EXTRACT(EPOCH FROM NOW()) * 1000,
			NOW(),
			'{"type":"EsN",'                   ||
      ' "cardId":'  || action_id || ','  ||
      ' "en":"'     || m[1]      || '",' ||
      ' "es":"'     || m[2]      || '",' ||
      ' "gender":"' || m[3]      || '"}'
		);
    action_id := action_id + 10;
   END LOOP;
END
$do$
