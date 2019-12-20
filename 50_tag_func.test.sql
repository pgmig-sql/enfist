/*
  test all enfist funcs
*/

SELECT set_config(pgmig.var_prefix('tag'), '_enfist_test0_', true);
SELECT set_config(pgmig.var_prefix('tag1'), '_enfist_test1_', true);



SAVEPOINT test_begin;
select pgmig.assert_count(4);

DELETE FROM pers.enfist_tag WHERE code LIKE '_enfist_test%';

-- ----------------------------------------------------------------------------
SELECT pgmig.assert_eq('tag_set'
, enfist.tag_set(pgmig.var('tag'), E'# anno1\nvar1=val1\n# anno2\nvar2="val 0"')
, true
);

-- ----------------------------------------------------------------------------
SELECT pgmig.assert_eq('tag_set_update'
, enfist.tag_set(pgmig.var('tag'), E'# anno1\nvar1=val1\n# anno2\nvar2="val 2"')
, false
);

-- ----------------------------------------------------------------------------
SELECT pgmig.assert_eq('tag_vars'
, enfist.tag_vars(pgmig.var('tag'))
, E'# anno1
var1=val1
# anno2
var2="val 2"'
);

-- ----------------------------------------------------------------------------
SELECT pgmig.assert_eq('tag_set1'
, enfist.tag_set(pgmig.var('tag1'),E'#test1')
, true
);

/*
SELECT pgmig.assert_eq('pkg_op_bef'
, (SELECT jsonb_build_object('code',code,'version',version) FROM pgmig.pkg where code='test_pgmig')
, '{
        "version": "v0.0",
        "code": "test_pgmig"
   }'::jsonb
);
ROLLBACK TO SAVEPOINT test_begin;


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
*/