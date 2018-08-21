/*
  Tables for stored proc documenting

*/

-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS pers.enfist_tag(
  code       TEXT PRIMARY KEY
, alias_for  TEXT REFERENCES pers.enfist_tag(code)
, data       TEXT
, updated_at TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
SELECT poma.comment('t', 'pers.enfist_tag', 'Файл настроек'
, 'code',  'Код'
, 'alias_for', 'Синоним для кода'
, 'data',   'Содержимое файла (если не синоним)'
, 'updated_at',  'Время последнего обновления'
);

-- -----------------------------------------------------------------------------
/*
  TODO: variable per row store

CREATE TABLE IF NOT EXISTS tag_var(
  code  TEXT REFERENCES tag ON DELETE CASCADE
, var   TEXT
, sort  INTEGER NOT NULL DEFAULT 0
, value TEXT
, anno  TEXT
, CONSTRAINT tag_var_pkey PRIMARY KEY (code, var)
);
COMMENT ON TABLE tag_var IS 'Config tag variables';
*/
-- -----------------------------------------------------------------------------
