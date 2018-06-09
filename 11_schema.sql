/*
  Создание схемы БД
  Используется в 'make create'
*/

-- Вывод в логи информации о коннекте
\conninfo

-- зависимости
SELECT poma.pkg_require('rpc');

-- Создание схемы
CREATE SCHEMA IF NOT EXISTS :PKG;
