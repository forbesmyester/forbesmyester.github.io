# Code In PostgreSQL: You can do lots with just IN, ORDER BY and LIMIT


## This series of articles

This is the first of the Code in PostgreSQL series of articles.

```unixpipe cat content-assets/code-in-postgresql/about-body.md
```

```unixpipe cat content-assets/code-in-postgresql/about-ergast.md
```

### Assumed level of SQL Knowledge

In this JavaScript example we will assume the writer has sufficient SQL knowledge to use a `WHERE` statement along with the ability to only return certain fields using `SELECT`. After this we will see how this can be accomplished in one single SQL statement using `IN`, `ORDER BY` and `LIMIT`.

## The aim

Lets say you want to find out the final points for drivers in the 2017 Formula 1 World Championship. The schema for the tables we will be using is as follows:

```unixpipe diagram-erd content-assets/2019-03-03-code-in-postgresql-in-order-by-limit/erd.svg
[races]
*raceId
year
round
circuitId
name
date
time
url


[driverStandings]
*driverStandingsId
+raceId
+driverId
points
position
positionText
wins

driverStandings *--1 races
```

An example of the data you would find in these tables is shown below:

#### races

| raceId | year | round | circuitId |           name           |    date    |   time   | url |
| -:     | -:   | -:    | -:        | -                        | -          | -        | - |
|    969 | 2017 |     1 |         1 | Australian Grand Prix    | 2017-03-26 | 05:00:00 | https://en.wikipedia.org/wiki/2017_Australian_Grand_Prix|
|    970 | 2017 |     2 |        17 | Chinese Grand Prix       | 2017-04-09 | 06:00:00 | https://en.wikipedia.org/wiki/2017_Chinese_Grand_Prix|
|    971 | 2017 |     3 |         3 | Bahrain Grand Prix       | 2017-04-16 | 15:00:00 | https://en.wikipedia.org/wiki/2017_Bahrain_Grand_Prix|
|    972 | 2017 |     4 |        71 | Russian Grand Prix       | 2017-04-30 | 12:00:00 | https://en.wikipedia.org/wiki/2017_Russian_Grand_Prix|
|    973 | 2017 |     5 |         4 | Spanish Grand Prix       | 2017-05-14 | 12:00:00 | https://en.wikipedia.org/wiki/2017_Spanish_Grand_Prix|


#### driversStandings

| driverStandingsId | raceId | driverId | points | position | positionText | wins |
| -:                | -:     | -:       | -:     | -:       | -            | -:   |
|             64782 |    855 |        3 |     63 |        7 | 7            |    0 |
|             64795 |    856 |        1 |    196 |        5 | 5            |    2 |
|             64797 |    856 |        4 |    212 |        3 | 3            |    1 |
|             64805 |    856 |        2 |     34 |       10 | 10           |    0 |
|             64810 |    856 |        3 |     67 |        7 | 7            |    0 |

The `driverStandings` table has the points for every driver in every race. The problem here is that there is no record in the `driverStandings` table for which season a `raceId` belongs to. So we need to get a bit creative... Here is one possible solution:

 1. Looking at the `races` table's `year` column, we can find all the `raceId` in 2017.
 2. If we can get all `races` in a given `year` we should be able to get the last race because the `round` will be the highest within that year.
 2. Find the `points` and `driverId` for the drivers who were in that `raceId` by reading the `driverStandings` table.
 3. Sort them by `points` descending.
 4. The very first row contains the `driverId` which has the most points in that season. This `driverId` is the world champion. The ones later on denote their final position (assuming the points differ).

## Implementing the JavaScript

### Libraries

<div class="hide-by-header">

#### sql-spitting-image/limit.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/limit.js
```
</div>

<div class="hide-by-header">

#### sql-spitting-image/select.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/select.js
```
</div>

<div class="hide-by-header">

#### sql-spitting-image/orderBy.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/orderBy.js
```
</div>

<div class="hide-by-header">

#### sql-spitting-image/orderByMulti.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/orderByMulti.js
```
</div>

### Main Code

```javascript file=content-assets/code-in-postgresql/2019-03-03-in-order-by-limit.js
```

This code, despite there being a lot of it is relatively straight forward. We get a list of `raceId` and `round` from the `qryRaces` function. Once we have this we will order by the `round` from largest to smallest and take the first one. This is the last race of the season.

After this we feed that `raceId` directly into the `qryStandings` functions to get the results from the last race. Finally we are forced to use a more complicated sorting function for stability, because some drivers have the same amount of points before presenting our desired columns.

<div class="pro-list">

### Pro's

 * There's some nice re-usable functions here.
 * The main code is quite concise and easy to understand.
</div>

<div class="con-list">

### Con's

 * Longer than SQL
 * We downloaded more data than necessary, in this case it is not too bad but it could have been much worse.
</div>

## SQL

```sql file=content-assets/code-in-postgresql/2019-03-03-in-order-by-limit.sql
```

Like the JavaScript we are using ordering (`ORDER BY`) and limiting (`LIMIT`) to get the highest `raceId` within 2017.

The `IN` clause can be used to match a column against a set of numbers. For example we may choose to write `WHERE "raceId" IN (4, 5, 7)` which would be the same thing as writing `WHERE "raceId" = 4 OR "raceId" = 5 OR "raceId" = 7`.

The smart thing here is that we are using a query to get the last `raceId` within the `IN` clause instead of a directly specified list of `raceId`.

Finally an `ORDER BY` statement is used to perform sorting of the final record set, you can sort by multiple fields or use many types of expressions.

<div class="pro-list">

### Pro's

 * Shorter than the JavaScript.
 * If this were called by JavaScript we would need only one Promise, which is much easier to write and reason about.
 * The inside of the `IN` clause can be ran and understood individually.
</div>

<div class="con-list">

### Con's

 * Is the `ORDER BY` / `LIMIT 1` a trick?
 * It seems in code you can give the contents of IN clause a name (`raceIds`) but this is not possible using SQL's `IN`, [or is it?]({% post_url 2019-03-12-code-in-postgresql-with %}).
</div>


## Results

```unixpipe cat content-assets/code-in-postgresql/2019-03-03-in-order-by-limit-result.csv | csvtk csv2md
```

```unixpipe cat assets/syntax-highlighting.html
```

```unixpipe cat content-assets/code-in-postgresql/code-in-postgresql.css | in-tags style
```

```unixpipe cat content-assets/code-in-postgresql/code-in-postgresql.js | in-tags script
```
Tags: code-in-postgresql, javascript, postgresql, postgresql
