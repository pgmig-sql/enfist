
SELECT poma.test('tag_set'); -- BOT
SELECT tag_set('test', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"'); -- EOT

SELECT poma.test('tag_vars'); -- BOT
SELECT tag_vars('test'); -- EOT

SELECT poma.test('tag'); -- BOT
SELECT code, alias_for, data, (updated_at IS NOT NULL) AS is_logged FROM tag('test'); -- EOT

SELECT poma.test('tag_del'); -- BOT
SELECT tag_del('test'); -- EOT

SELECT poma.test('tag_del (false)'); -- BOT
-- Returns FALSE = tag not found
SELECT tag_del('test'); -- EOT
