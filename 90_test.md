#  enfist/90_test
## tag_set

```sql
SELECT enfist.tag_set('_enfist_test_', E'#anno1\nvar1=val1\n#anno2\nvar2="val 0"')
;
```
|tag_set 
|--------
|t

## tag_set update

```sql
SELECT enfist.tag_set('_enfist_test_', E'#anno1\nvar1=val1\n#anno2\nvar2="val 2"')
;
```
|tag_set 
|--------
|f

## tag_vars

```sql
SELECT enfist.tag_vars('_enfist_test_')
;
```
|  tag_vars   
|-------------
|#anno1      +
|var1=val1   +
|#anno2      +
|var2="val 2"

## tag_set1

```sql
SELECT enfist.tag_set('_enfist_test1_', E'#test1')
;
```
|tag_set 
|--------
|t

## tag (sort 1, 2)

```sql
SELECT code, data, (updated_at IS NOT NULL) AS is_logged FROM enfist.tag('_enfist_test')
;
```
|     code      | data | is_logged 
|---------------|------|-----------
|_enfist_test_  |      | t
|_enfist_test1_ |      | t

## tag sort 1 (-1, 2)

```sql
SELECT code, updated_at = CURRENT_DATE-1 as is_prev FROM enfist.tag('_enfist_test', a_sort := 1)
;
```
|     code      | is_prev 
|---------------|---------
|_enfist_test1_ | f
|_enfist_test_  | f

## tag sort 2 (2, 1)

```sql
SELECT code, updated_at = CURRENT_DATE-1 as is_prev FROM enfist.tag('_enfist_test', a_sort := 2)
;
```
|     code      | is_prev 
|---------------|---------
|_enfist_test_  | f
|_enfist_test1_ | f

## tag sort 3 (2, -1)

```sql
SELECT code, updated_at = CURRENT_DATE-1 as is_prev FROM enfist.tag('_enfist_test', a_sort := 3)
;
```
|     code      | is_prev 
|---------------|---------
|_enfist_test1_ | f
|_enfist_test_  | f

## tag sort 3 (2x, -1)

```sql
SELECT code, updated_at = CURRENT_DATE-1 as is_prev FROM enfist.tag('_enfist_test', a_sort := 3)
;
```
|     code      | is_prev 
|---------------|---------
|_enfist_test_  | t
|_enfist_test1_ | f

## tag sort 4 (-2x, 1)

```sql
SELECT code, updated_at = CURRENT_DATE-1 as is_prev FROM enfist.tag('_enfist_test', a_sort := 4)
;
```
|     code      | is_prev 
|---------------|---------
|_enfist_test1_ | f
|_enfist_test_  | t

## tag page

```sql
SELECT code from enfist.tag('_enfist_test', a_off := 1, a_lim := 1)
;
```
|     code      
|---------------
|_enfist_test1_

## tag_count

```sql
SELECT enfist.tag_count('_enfist_test')
;
```
|tag_count 
|----------
|        2

## tag_del

```sql
SELECT enfist.tag_del('_enfist_test_')
;
```
|tag_del 
|--------
|t

## tag_del (false)

```sql
SELECT enfist.tag_del('_enfist_test_')
;
```
|tag_del 
|--------
|f

