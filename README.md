

## Download the frames

If you don't use compression:

```
<script type="text/javascript">
<!--
Sorry your browser doesn't support compressed web pages. Click the link below for the original Java version.
```

```
curl -sH 'Accept-encoding: gzip' www.asciimation.co.nz | gunzip - > site.html
du -hs site.html
2.0M	site.html
```


looks like this

```
var film = '2\n\n\n\n\n\n\n\n\n\n\n\n\n\n15\n\n\n\n\n                       WWW.ASCIIMATION.CO.NZ\n\
…
                      www.asciimation.co.nz\n\n\n\n\n1\n\n\n\n\n\n\n\n\n\n\n\n\n\n�\n'.split('\n');
```


```sql
 create table film (i serial primary key, count int, frame text);
```


```
create or replace function go(speed numeric, ctr bigint)
returns text
as $$
begin
perform pg_sleep(count*speed) from film where i = ctr-1;
return (select frame from film where i = ctr);
end
$$
language plpgsql;
```


