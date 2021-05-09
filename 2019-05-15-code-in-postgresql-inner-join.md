# Code In PostgreSQL: Combining data from multiple tables with INNER JOIN

## This series of articles

This is the third of the Code in PostgreSQL series of articles.

```unixpipe cat content-assets/code-in-postgresql/about-body.md
```

```unixpipe cat content-assets/code-in-postgresql/about-ergast.md
```

## The Aim

At the end of the [last article](2019-03-12-code-in-postgresql-with.adoc) we had the following dataset:

```unixpipe cat content-assets/code-in-postgresql/2019-03-03-in-order-by-limit-result.csv | csvtk csv2md
```

I would like to augment this dataset with the names of the drivers, so the results would look something like the following:

| points | driverId | forename   | surname   | year |
| -:     | -:       | :-         | :-        | -:   |
|    363 | 1        | _forename_ | _surname_ | 2017 |

Where _forename_ and _surname_ have the real values in.

## Table Structure

```unixpipe diagram-erd content-assets/2019-05-15-code-in-postgresql-inner-join/erd.svg
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

[drivers]
*driverId
driverRef
number
code
forename
surname
dob
nationality
url


driverStandings *--1 races
driverStandings *--1 drivers
```

## Table Data


### races

| raceId | year | round | circuitId |           name           |    date    |   time   |                             url                             |
| -:     | -:   | -:    | -:        | :-                       | -:         | -:       | :-                                                          |
|    971 | 2017 |     3 |         3 | Bahrain Grand Prix       | 2017-04-16 | 15:00:00 | https://en.wikipedia.org/wiki/2017_Bahrain_Grand_Prix       |
|    977 | 2017 |     9 |        70 | Austrian Grand Prix      | 2017-07-09 | 12:00:00 | https://en.wikipedia.org/wiki/2017_Austrian_Grand_Prix      |

### driverStandings

| driverStandingsId | raceId | driverId | points | position | positionText | wins |
| -:                | -:     | -:       | -:     | -:       | :-           | -:   |
|             64795 |    856 |        1 |    196 |        5 | 5            |    2 |
|             64810 |    856 |        3 |     67 |        7 | 7            |    0 |

### drivers

| driverId | driverRef | number | code | forename | surname  |    dob     | nationality |                     url                      |
| -: | :- | -: | :- | :- | :- | -: | :- | :- |
|        2 | heidfeld  |        | HEI  | Nick     | Heidfeld | 1977-05-10 | German      | http://en.wikipedia.org/wiki/Nick_Heidfeld |
|        4 | alonso    |     14 | ALO  | Fernando | Alonso   | 1981-07-29 | Spanish     | http://en.wikipedia.org/wiki/Fernando_Alonso |

## Implementing the JavaScript

If we think about what code we had in the previous article there are two peices of functionality  we're missing. These are:

 1. The ability to find a row in the `drivers` table that matches a row in our current result set.
 2. The ability to mix/join this row from `drivers` with our current results.

I'm going to aim to write code that is highly reusable and also still performs well on very large data sets.

### Finding drivers efficiently

The obvious answer to finding a `driver` from a list of `drivers` would be to use `Array.find()`... something lie the following?

```javascript file=content-assets/code-in-postgresql/2019-05-15-inner-join-arrayFind.js
```

This is certainly a reusable piece of code and was easy to write and hopefully for you to understand.

I can see two problems here though.

The first problem is performance. When we need to look up a `driverId` we need to scan all the rows in `drivers` up until the point we find the correct one. We will be doing this for all of the (hypothetically millions of) `driverId` we want to look up. So I'm pretty sure the performance characteristics of this is not great.

The other short coming I can see is that it will only ever retreive one row. This is often what we want to acheive, but not always. An example of when this is not enough is when you have one customerId and you want to find / match / join it to all orders in another table.

The following would perform much better and allow returning multiple rows:

#### sql-spitting-image/_indexBySimple.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/_indexBySimple.js
```

The `indexBySimple` function can scan through the whole set of `drivers` and fill up a Map with the key being `driverId` and the values are the actual rows with have that `driverId`.  Once we have this Map looking up drivers by `driverId` will become very cheap.

### Mixing a `drivers` record with our current results

Combining an Object of one type (`driverRow`) with another (`currentResults`) is really easy in ES6 because you can simply destruct the objects to create new one like the following

```javascript
    const newObject = {...currentResults, ...driverRow};
```

## Building the libraries

#### sql-spitting-image/innerJoinSimple.js

Because of all our planning the innerJoinSimple library has become really quite simple.

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/innerJoinSimple.js
```

Reading through it you can see that the first thing it does is build an index for the right set of data.

After this it will read through all of the left set of data, checking if it can be joined to the right, if it can it will be.

## Libraries

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

<div class="hide-by-header">

#### sql-spitting-image/limit.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/limit.js
```
</div>

<div class="hide-by-header">

#### sql-spitting-image/qryTable.js

```javascript file=content-assets/code-in-postgresql/sql-spitting-image/qryTable.js
```
</div>


## Main Code

The last thing to do is glue all the code together. See below:

```javascript file=content-assets/code-in-postgresql/2019-05-15-inner-join.js
```

Again we have a rather large amount of code, however I again think it is quite readable.

Even if you disagree and don't like this code I hope you will agree that this amount of code could easily be wrote quite badly.

<div class="pro-list">

### Pro's

 * Broken down quite well into bite size peices.
 * A lot of this code is quite reusable, if you wish.
</div>

<div class="con-list">

### Con's

 * There's a lot of it.
 * We are again requesting more data than is required.
</div>

## The SQL

```javascript file=content-assets/code-in-postgresql/2019-05-15-inner-join.sql
```

<div class="pro-list">

## Pro's

 * Shorter than the JavaScript.
 * If this were called by JavaScript we would need only one Promise, which is much easier to write and reason about.
 * The `INNER JOIN` relatively effortlessly mixes in data about drivers into what we had before.
</div>

<div class="con-list">

## Con's

 * There's not much here that's re-usable, other than the knowledge you've acquired.
</div>


```unixpipe cat assets/syntax-highlighting.html
```

```unixpipe cat content-assets/code-in-postgresql.css | in-tags style
```

```unixpipe cat content-assets/code-in-postgresql.js | in-tags script
```
Tags: code-in-postgresql, javascript, postgresql
