CREATE TABLE actions (
  action_id         INT NOT NULL,
  type              TEXT NOT NULL,
  created_at_millis BIGINT NOT NULL,
  synced_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  card_add_json     TEXT,
  card_update_json  TEXT,
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
    ['skin','piel','F','skin is burnt and peeled']
  , ['arm','brazo','M','arm tan is bronze']
  , ['leg','pierna','F','leggo my leg or I''ll pee urine']
  , ['heart','corazón','M','']
  , ['stomach','estómago','M','']
  , ['eye','ojo','M','']
  , ['nose','nariz','F','']
  , ['mouth','boca','F','']
  , ['ear','oreja','F','ear rings of oreos']
  , ['face','cara','F','face got cut off']
  , ['neck','cuello','M','neck vein was cut way open']
  , ['finger','dedo','M','finger technique by Dedone']
  , ['foot','pie','M','foot stays in the state of PA']
  , ['thigh','muslo','M','thigh-high boots from wild moose']
  , ['ankle','tobillo','M','ankle stung to be young']
  , ['elbow','codo','M','elbow dipped and coated']
  , ['wrist','muñeca','F','wrist watch says "Moon not yet come!"']
  , ['body','cuerpo','M','body bag for corpse']
  , ['tooth','diente','M','']
  , ['hand','mano','F','hand me the manual']
  , ['back','espalda','F','back hair is bald']
  , ['hip','cadera','F','hipster can''t dare']
  , ['jaw','mandíbula','F','']
  , ['shoulder','hombro','M','shoulder on, my brother']
  , ['thumb','pulgar','M','thumb war: push and pull hard']
  , ['tongue','lengua','F','tongue length for languages']
  , ['throat','garganta','F','throat can''t gargle gargantuan']
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
			card_add_json
		) VALUES (
      action_id,
			'ADD_CARD',
			EXTRACT(EPOCH FROM NOW()) * 1000,
			NOW(),
			'{"type":'      || '"EsN",'  ||
      ' "cardId":'    || action_id || ','  ||
      ' "en":"'       || m[1]      || '",' ||
      ' "es":"'       || m[2]      || '",' ||
      ' "gender":"'   || m[3]      || '",' ||
      ' "mnemonic":'  || to_json(m[4]::text)|| '}'
		);
    action_id := action_id + 10;
   END LOOP;
END
$do$;

CREATE TABLE exposures (
  id            SERIAL NOT NULL,
  type          TEXT NOT NULL,
  es            TEXT NOT NULL,
  prompted_at   BIGINT NOT NULL,
  responded_at  BIGINT NOT NULL,
  PRIMARY KEY (id)
);
