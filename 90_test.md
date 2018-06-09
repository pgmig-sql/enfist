#  enfist/90_test
## enfist/90_test

```sql
SELECT tag_set('test', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"')
;
```
|tag_set 
|--------
|t

## enfist/90_test

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

## enfist/90_test

```sql
SELECT code, alias_for, data, (updated_at IS NOT NULL) AS is_logged FROM tag('test')
;
```
|code | alias_for | data | is_logged 
|-----|-----------|------|-----------
|test |           |      | t

## enfist/90_test

```sql
SELECT tag_del('test')
;
```
|tag_del 
|--------
|t

## enfist/90_test

```sql
SELECT tag_del('test')
;
```
|tag_del 
|--------
|f

