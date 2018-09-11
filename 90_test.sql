/*
  test all enfist funcs
*/

\set MASK _enfist_test
-- underscore order depends on collation, so don't mix it with other chars
\set TAG :MASK  '0_'
\set TAG1 :MASK '1_'

-- do not show deleted rows count
\set QUIET on
DELETE FROM pers.enfist_tag WHERE code LIKE :'MASK'||'%';
\set QUIET off


SELECT poma.test('tag_set'); -- BOT
SELECT enfist.tag_set(:'TAG', E'#anno1\nvar1=val1\n#anno2\nvar2="val 0"'); -- EOT

SELECT poma.test('tag_set update'); -- BOT
SELECT enfist.tag_set(:'TAG', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"'); -- EOT

SELECT poma.test('tag_vars'); -- BOT
SELECT enfist.tag_vars(:'TAG'); -- EOT

SELECT poma.test('tag_set1'); -- BOT
SELECT enfist.tag_set(:'TAG1', E'#test1'); -- EOT

-- set all records to same updated_at
UPDATE pers.enfist_tag SET updated_at = CURRENT_DATE WHERE code ~ :'MASK';

SELECT poma.test('tag (sort 1, 2)'); -- BOT
SELECT code, data, (updated_at IS NOT NULL) AS is_logged FROM enfist.tag(:'MASK'); -- EOT

\set FILE :BUILD_DIR :TEST .macro.sql
\set PREV_DATE CURRENT_DATE-1

\set SORT 1
\set ANNO '-1, 2'
\i :FILE

\set SORT 2
\set ANNO '2, 1'
\i :FILE

\set SORT 3
\set ANNO '2, -1'
\i :FILE

-- set updated_at to different
UPDATE pers.enfist_tag SET updated_at = :PREV_DATE WHERE code = :'TAG';

-- \set SORT 3
\set ANNO '2x, -1'
\i :FILE

\set SORT 4
\set ANNO '-2x, 1'
\i :FILE

SELECT poma.test('tag page'); -- BOT
SELECT code from enfist.tag(:'MASK', a_off := 1, a_lim := 1); -- EOT

SELECT poma.test('tag_count'); -- BOT
SELECT enfist.tag_count(:'MASK'); -- EOT

SELECT poma.test('tag_del'); -- BOT
SELECT enfist.tag_del(:'TAG'); -- EOT

SELECT poma.test('tag_del (false)'); -- BOT

-- Returns FALSE = tag not found
SELECT enfist.tag_del(:'TAG'); -- EOT
