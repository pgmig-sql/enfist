/*
  Functions for env tag list/get/set

*/

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag (a_mask TEXT DEFAULT NULL, a_show_data BOOL DEFAULT FALSE) RETURNS TABLE (
  code       TEXT
, alias_for  TEXT
, data       TEXT
, updated_at TIMESTAMP(0)
) STABLE LANGUAGE 'sql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  SELECT
    code
  , alias_for
  , CASE WHEN $2 THEN data ELSE NULL END AS data
  , updated_at
    FROM tag
   WHERE code ~ COALESCE($1, '')
   ORDER BY code
$_$;

SELECT rpc.add('tag'
, 'Список тегов'
, '{
    "a_mask": "Regexp тега"
  , "a_show_data": "Включить в результат переменные"
   }'
, '{
    "code":    "Тег"
  , "alias_for": "Тег, откуда берутся переменные"
  , "data": "Переменные тега"
  , "updated_at": "Время последнего изменения"
  }'
,'{}'
, 5
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_vars(a_code TEXT) RETURNS TEXT STABLE LANGUAGE 'sql'
SET SEARCH_PATH FROM CURRENT AS
$_$
 -- TODO: recurse
  SELECT data FROM tag WHERE code = $1
$_$;

SELECT rpc.add('tag_vars'
, 'Переменные тега'
, '{"a_code":  "Тег"}'
, '{"tag_vars":"Переменные тега"}'
,'{}'
, 5
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_set(
  a_code TEXT
, a_data TEXT
) RETURNS BOOL VOLATILE LANGUAGE 'plpgsql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  DECLARE
    v_is_new BOOL := TRUE;
  BEGIN
    IF EXISTS( SELECT 1 FROM tag WHERE code = a_code) THEN
      DELETE FROM tag WHERE code = a_code;
      v_is_new := FALSE;
    END IF;
    INSERT INTO tag (code, data) VALUES (a_code, a_data);
    RETURN v_is_new;
  END;
$_$;

SELECT rpc.add('tag_set'
, 'Сохранить переменные тега'
, '{"a_code": "Тег", "a_data": "Переменные тега"}'
, '{"tag_set": "TRUE если тег новый"}'
,'{}'
, 5
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_append(a_code TEXT, a_data TEXT) RETURNS BOOL VOLATILE LANGUAGE 'plpgsql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  BEGIN
    UPDATE tag SET data=data || E'\n' || a_data WHERE code = a_code;
    RETURN FOUND;
  END;
$_$;

SELECT rpc.add('tag_append'
, 'Добавить данные к переменным тега'
, '{"a_code":  "Тег", "a_data": "Переменные тега"}'
, '{"tag_append":"Данные добавлены"}'
,'{}'
, 5
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_del(a_code TEXT) RETURNS BOOL VOLATILE LANGUAGE 'plpgsql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  BEGIN
    DELETE FROM tag WHERE code = a_code;
    RETURN FOUND;
  END;
$_$;

SELECT rpc.add('tag_del'
, 'Удалить тег'
, '{"a_code":  "Тег"}'
, '{"tag_del":"Тег удален"}'
,'{}'
, 5
);
