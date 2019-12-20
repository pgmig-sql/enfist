
CREATE OR REPLACE FUNCTION cleanup(a_with_pers BOOL DEFAULT FALSE) RETURNS VOID LANGUAGE PLPGSQL AS $_$
BEGIN
	RAISE NOTICE 'cleanup(%)',a_with_pers;
--  Удалить все регистрации методов пакета в RPC.
--  При создании методы повторят регистрацию
PERFORM rpc.nsp_clear('enfist');
	drop schema enfist cascade;
	IF a_with_pers THEN
--		drop schema pers cascade;
	END IF;
END;
$_$;
SELECT pgmig.comment('f', 'cleanup', 'Cleanup package');
