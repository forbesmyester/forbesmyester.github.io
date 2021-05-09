
### About the Ergast data set

For this series of articles we will be using the [Ergast](https://ergast.com/mrd) data set, which is a provided under the [Attribution-NonCommercial-ShareAlike 3.0 Unported Licence](http://creativecommons.org/licenses/by-nc-sa/3.0/).

### Setting up the Ergast database within PostgreSQL

To set up the [Ergast](https://ergast.com/mrd) database within PostgreSQL I did the following:

I allowed `psql` and friends to work without me having to put in a password all the time by configuring the [PostgreSQL environmental variables](https://www.postgresql.org/docs/current/libpq-envars.html).

```bash
export PGUSER=postgres PGPASSWORD=postgres PGDATABASE=postgres PGHOST=127.0.0.1
```

Then import the [Ergast](http://ergast.com/) database. NOTE: At the time of writing I was unable to install the PostgreSQL version.

```bash
wget -O /tmp/f1db_ansi.sql.gz http://ergast.com/downloads/f1db_ansi.sql.gz
cat /tmp/f1db_ansi.sql.gz | \
    gzip -d | \
    sed 's/int(..)/int/' | \
    sed 's/ \+AUTO_INCREMENT//' | \
    sed "s/\\\'/\'\'/g" | \
    sed 's/UNIQUE KEY \"\(\w\+\)\"/UNIQUE /' | \
    sed 's/^ *KEY .*(\"\(.*\)\")/CHECK ("\1" > 0)/' | \
    sed 's/ date NOT NULL DEFAULT .0000.*,/ date,/'| psql
```
