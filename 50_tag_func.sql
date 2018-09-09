/*
  Functions for env tag list/get/set

*/

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag (
  a_mask TEXT DEFAULT NULL
, a_show_data BOOL DEFAULT FALSE
, a_sort INTEGER DEFAULT 0
, a_off    integer DEFAULT 0
, a_lim    integer DEFAULT 25
) RETURNS SETOF pers.enfist_tag STABLE LANGUAGE 'sql' AS
$_$
  SELECT
    code
  , alias_for
  , CASE WHEN a_show_data THEN data ELSE NULL END AS data
  , updated_at
    FROM pers.enfist_tag
   WHERE code ~ COALESCE($1, '')
   ORDER BY 
   /*
  Sort:
   1  2  0
   1 -2  (skip: code is unique)
  -1  2  1
  -1 -2  (skip: code is unique)
   2  1  2
   2 -1  3
  -2  1  4
  -2 -1  5
   */
     CASE WHEN a_sort IN (0) THEN code ELSE NULL END ASC
   , CASE WHEN a_sort IN (1) THEN code ELSE NULL END DESC

   , CASE WHEN a_sort IN (2,3) THEN updated_at ELSE NULL END ASC
   , CASE WHEN a_sort IN (4,5) THEN updated_at ELSE NULL END DESC

   , CASE WHEN a_sort IN (2,4) THEN code ELSE NULL END ASC
   , CASE WHEN a_sort IN (3,5) THEN code ELSE NULL END DESC

   LIMIT NULLIF(a_lim, 0) OFFSET a_off
$_$;

SELECT rpc.add('tag'
, 'Список тегов'
, '{
    "a_mask": "Regexp тега"
  , "a_show_data": "Включить в результат переменные"
   }'
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_count (
  a_mask TEXT DEFAULT NULL
) RETURNS INTEGER STABLE LANGUAGE 'sql' AS
$_$
  SELECT count(*)::INTEGER
    FROM pers.enfist_tag
   WHERE code ~ COALESCE($1, '')
$_$;

SELECT rpc.add('tag_count'
, 'Количество тегов'
, '{
    "a_mask": "Regexp тега"
   }'
);
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_vars(a_code TEXT) RETURNS TEXT STABLE LANGUAGE 'sql'
SET SEARCH_PATH FROM CURRENT AS
$_$
 -- TODO: recurse
  SELECT data FROM pers.enfist_tag WHERE code = $1
$_$;

SELECT rpc.add('tag_vars'
, 'Переменные тега'
, '{"a_code":  "Тег"}'
, '{"tag_vars":"Переменные тега"}'
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
    IF EXISTS( SELECT 1 FROM pers.enfist_tag WHERE code = a_code) THEN
      DELETE FROM pers.enfist_tag WHERE code = a_code;
      v_is_new := FALSE;
    END IF;
    INSERT INTO pers.enfist_tag (code, data) VALUES (a_code, a_data);
    RETURN v_is_new;
  END;
$_$;

SELECT rpc.add('tag_set'
, 'Сохранить переменные тега'
, '{"a_code": "Тег", "a_data": "Переменные тега"}'
, '{"tag_set": "TRUE если тег новый"}'
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_append(a_code TEXT, a_data TEXT) RETURNS BOOL VOLATILE LANGUAGE 'plpgsql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  BEGIN
    UPDATE pers.enfist_tag SET data=data || E'\n' || a_data WHERE code = a_code;
    RETURN FOUND;
  END;
$_$;

SELECT rpc.add('tag_append'
, 'Добавить данные к переменным тега'
, '{"a_code":  "Тег", "a_data": "Переменные тега"}'
, '{"tag_append":"Данные добавлены"}'
);

-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION tag_del(a_code TEXT) RETURNS BOOL VOLATILE LANGUAGE 'plpgsql'
SET SEARCH_PATH FROM CURRENT AS
$_$
  BEGIN
    DELETE FROM pers.enfist_tag WHERE code = a_code;
    RETURN FOUND;
  END;
$_$;

SELECT rpc.add('tag_del'
, 'Удалить тег'
, '{"a_code":  "Тег"}'
, '{"tag_del":"Тег удален"}'
);
