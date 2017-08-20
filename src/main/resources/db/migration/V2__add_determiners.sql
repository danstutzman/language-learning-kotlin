DO
$do$
DECLARE
  m   varchar[];
  arr varchar[] := array[
    ['the','el','M','S']
  , ['the','la','F','S']
  , ['the','los','M','P']
  , ['the','las','F','P']
  , ['a','un','M','S']
  , ['a','una','F','S']
  , ['some','unos','M','P']
  , ['some','unas','F','P']
  , ['my','mi','','S']
  , ['my','mis','','P']
  , ['this','este','M','S']
  , ['this','esta','F','S']
  , ['these','estos','M','P']
  , ['these','estas','F','P']
  , ['every','cada','','S']
  , ['two','dos','','P']
  , ['three','tres','','P']
  ];
  action_id int8;
BEGIN
  EXECUTE 'SELECT COALESCE(MAX(action_id), 0) + 10 FROM actions WHERE action_id % 10 = 0' INTO action_id;
    
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
      '{"type":'      || '"EsD",'  ||
      ' "cardId":'    || action_id || ','  ||
      ' "en":"'       || m[1]      || '",' ||
      ' "es":"'       || m[2]      || '",' ||
      ' "gender":"'   || m[3]      || '",' ||
      ' "number":"'   || m[4]      || '"}'
    );
    action_id := action_id + 10;
   END LOOP;
END
$do$;
