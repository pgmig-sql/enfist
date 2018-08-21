/*
  Создание схемы БД
  Используется в 'make create'
*/

CREATE SCHEMA :PKG;
SELECT poma.comment('n', :'PKG','Подсистема enfist');

CREATE SCHEMA IF NOT EXISTS pers;
SELECT poma.comment('n', 'pers','Persistent data');