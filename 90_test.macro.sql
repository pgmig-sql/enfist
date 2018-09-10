-- test for different sort orders

SELECT poma.test('tag sort ' || :'SORT' || ' (' || :'ANNO' || ')'); -- BOT
SELECT code, updated_at = :PREV_DATE as is_prev FROM enfist.tag(:'MASK', a_sort := :SORT); -- EOT
