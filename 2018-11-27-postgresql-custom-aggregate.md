# Creating a custom aggregate in PostgreSQL


## Why use an aggregate instead of returning all the data?

Sometimes you do not need all the data brought from the database into your normal programming language. Using normal aggregate functions such as [`SUM`, `COUNT` or `AVERAGE`](https://www.postgresql.org/docs/8.2/functions-aggregate.html) you may save your database server, network and application server massive amounts of network activity, a lot of time and potentially yourself a lot of work.

## But there is no function included for what I want!

While PostgreSQL has many different types of aggregate functions included, sometimes what you need is a little too custom for it to be included out of the box. For this there is the ability to create your own [custom aggregates](https://www.postgresql.org/docs/9.1/sql-createaggregate.html) using a relatively easy to understand API.

## The scenario

Suppose we want to find out how long (in time) a particular race is. We could just take the fastest time, but there may be an exceptional competitor far faster than everyone else. We could also take an average of all the finishers, but that may include some really slow competitors. Another option is to take the top `n` competitors and find the average time. This is the method we will describe for this tutorial.

## How to define a custom aggregate

A custom aggregate can be as easy as filling in the gaps of the following:

```sql file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate-the-aggregate-api.sql
```

We have a few missing elements here, but don't worry, I will explain what they
are and then we will fill them in.

## If we were writing this in JavaScript...

Using a [`reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce) function would get us a long way towards finding the answer. Reduce in Javascript has the following signature:

```javascript
arr.reduce(callback[, initialValue])
```

And the `callback` has the following signature:

```javascript
callback(accumulator, currentValue)
```

Therefore if you wanted to get the average of the three highest numbers you may write the following

```javascript file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate.js
```

And get the answer `2`.

## Converting the JavaScript back to SQL

### stype

The `stype` is the type of the `accumulator`, `initialValue` and `reduceResult`.  This would be called an "Array of Number" in JavaScript, `number[]` in TypeScript, but in SQL it would be `bigint[]`.

### initcond

The `initcond` is the value of `initialValue` from the JavaScript code. However `initcond` is weird as you must express it as a `varchar`, as if it would be typecast into the `stype`. If you were to run a `select '{1,2,3}'::bigint[]` query you would select an array of bigint with numbers `1`, `2` and `3` within, so `'{}'` is the correct value.

### sfunc

We are now making progress because the `sfunc` is the `callback` from the reduce function. If we were only intending our aggregate to take one argument it would actually have an identical signature.

However did you notice that `callback` really has three parameters, `accumulator`, `currentValue` as an actual parameters and `comp_count` from the wrapping function. As `callback` needs all these arguments, so does our aggregate (`sfunc`), as below.

```sql file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate-the-sfunc.sql
```

In this function we're creating a [common table expression](https://www.postgresql.org/docs/9.1/queries-with.html) with the lowest `n` values stored within the `acc` array with `row_time` appended using the [unnest](https://www.postgresql.org/docs/9.2/functions-array.html) function.

After this we just use the [array_agg](https://www.postgresql.org/docs/9.2/functions-aggregate.html) function to re-transform that common table expression back into an array.

### finalfunc

Lastly we have the `finalfunc` which, in our JavaScript takes the result of the `sfunc` (`bigint[]`) and averages the values within. This is exactly the same as the `finalizer()` function in the JavaScript implementation.

```sql file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate-the-finalfunc.sql
```

### Tying it all together

We have now discussed, and hopefully understood all the component parts to create an aggregate so we should be able to substitute the values in. Once you have created the `sfunc` and `finalfunc` functions you should be able to run the following to create the aggregate.

```sql file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate-the-aggregate.sql
```

## Does it work?

```sql file=content-assets/2018-11-09-sql-custom-aggregate/2018-11-09-sql-custom-aggregate-demo.sql
```

Gives the answer `2`, so appears to.

I actually wrote tests while preparing this blog post. When I have a write up complete I will share them too.

Tags: postgresql
