\set NAME 'tag_set' -- BOT
SELECT tag_set('test', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"'); -- EOT

\set NAME 'tag_vars' -- BOT
SELECT tag_vars('test'); -- EOT

\set NAME 'tag' -- BOT
SELECT code, alias_for, data, (updated_at IS NOT NULL) AS is_logged FROM tag('test'); -- EOT

\set NAME 'tag_del' -- BOT
SELECT tag_del('test'); -- EOT

\set NAME 'tag_del (false)' -- BOT
-- Returns FALSE = tag not found
SELECT tag_del('test'); -- EOT

\set NAME 'rpc methods' -- BOT
SELECT * FROM rpc.index(:'SCH') WHERE code LIKE 'tag%' ORDER BY code; -- EOT