#  enfist/90_test
## tag_set

```sql
SELECT tag_set('test', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"')
;
```
|tag_set 
|--------
|t

## tag_vars

```sql
SELECT tag_vars('test')
;
```
|  tag_vars   
|-------------
|#anno1      +
|var1=val1   +
|#anno2      +
|var2="val 2"

## tag

```sql
SELECT code, alias_for, data, (updated_at IS NOT NULL) AS is_logged FROM tag('test')
;
```
|code | alias_for | data | is_logged 
|-----|-----------|------|-----------
|test |           |      | t

## tag_del

```sql
SELECT tag_del('test')
;
```
|tag_del 
|--------
|t

## tag_del (false)

```sql
SELECT tag_del('test')
;
```
|tag_del 
|--------
|f

