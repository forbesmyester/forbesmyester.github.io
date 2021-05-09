# Code In PostgreSQL: You can use WITH to name specific parts of SQL

## This series of articles

This is the second of the Code in PostgreSQL series of articles.

```unixpipe cat content-assets/code-in-postgresql/about-body.md
```

```unixpipe cat content-assets/code-in-postgresql/about-ergast.md
```

### Assumed level of SQL Knowledge

In this JavaScript example we will assume the writer has sufficient SQL knowledge to use a `WHERE` statement along with the ability to only return certain fields using `SELECT`. After this we will see how this can be accomplished in one single SQL statement using `IN`, `ORDER BY` and `LIMIT`.

## Where we are

We saw [in the previous article](2019-03-03-code-in-postgresql-in-order-by-limit.md) how we could select rows from one table using a condition on another table. In doing this we noticed that the SQL we created did not give a name to the section of code within the `IN (...)` clause, which we did in the JavaScript code.

For the next few articles our SQL will be simple enough that we will not feel a great need to name sections of code. At some point however, as the complexity ramps up, we're going to want to start naming sections of our SQL to enhance readability.

### The original SQL

```sql file=content-assets/code-in-postgresql/2019-03-03-in-order-by-limit.sql
```

### The aim

We would like to give a name to the section of code within the `IN (...)` clause.

## Common Table Expressions

Functions in code are magical, yes they have a name, take parameters and give you back a result, but the amazing thing is that they have a name. Because they have names you are not forced to think about their internal workings. You can think about a named function as a distinct thing in and of itself, which frees your mind to think about the larger picture and higher level concepts.

Giving names to things is not an alien concept to SQL. As you can see in "The original SQL" we actually gave the third column whose value is `2017` the name "year". You can also name, or alias other things within your SQL but this falls far short of how we think (or not) about functions.

Common Table Expressions are the closest I have found to being able to name and refer to sections of SQL.

### The SQL

```sql file=content-assets/code-in-postgresql/2019-03-12-with.sql
```

IN the above code we have taken the contents of the `IN (...)` statement and moved it into a common table expression called `racesIn2017` at the top. We then have to select from that common table expression within the `IN (...)` clause again so in characters typed we have something longer, but we have achieved something else...

There is no `WHERE` within the `IN (...)` clause any more, that complexity has been moved to the common table expression. WHERE is not difficult to understand but obviously the complexity we could have abstracted away and named in the common table expressions could have been far far greater.

<div class="pro-list">

### Pro's

 * The ability to name and refer to a section of code is incredibly important because the developer can think about it as one thing, as opposed to the details that make it up.

</div>

<div class="con-list">

### Con's

 * Common table expressions, from what I have seen, are optimized individually, [not in the context of the main query](https://medium.com/@hakibenita/be-careful-with-cte-in-postgresql-fca5e24d2119). This looks to have [changed in PostgreSQL 12](https://www.postgresql.org/about/news/1943/).

</div>

## Results

The results are identical to the [previous version](2019-03-03-code-in-postgresql-in-order-by-limit.md)


```unixpipe cat content-assets/code-in-postgresql/2019-03-03-in-order-by-limit-result.csv | csvtk csv2md
```

```unixpipe cat assets/syntax-highlighting.html
```

```unixpipe cat content-assets/code-in-postgresql.css | in-tags style
```

```unixpipe cat content-assets/code-in-postgresql.js | in-tags script
`
Tags: code-in-postgresql, javascript, postgresql
