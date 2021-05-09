# When.js Vs Ramda


Something unfortunate happened to me over the weekend... I was writing code using the great [Ramda](http://ramdajs.com/), there was promises going on and the code was wonderful... Then along came the awesome [When.js](https://github.com/cujojs/when) to solve my more complicated future based problems but this made me write code like the following:

```
return when.map(
    R.map(getUserIds, sittings),
    whenGuard(whenGuard.n(1), getUsers)
).then(processUser);
```

This was enough to make me cry. It's not that I don't love both of these tools but the fact that Ramda takes it's arguments in the proper way `R.map(mapping_function, what_to_map_over)` (because it does [currying](http://hughfdjackson.com/javascript/why-curry-helps/)) while when.js does the more javascript centric way of `when.map(what_to_map_over, mapping_function)` makes absolutely horrible code!

So I'm sold on Ramda already, it's a lot nicer to work with than [other](http://underscorejs.org/) [libraries](https://lodash.com/) though I do appreciate them existing because at least they have made some people think in different ways than they used to. Still flip flopping of parameter order in my code has to be stopped right now.

While thinking about this I realised that I was only using `when.all`, `when.map` (always with a guard of 1) and the standard promise functionality from when.js. The guard of 1 is a really important point, this is essentially a limit on concurrency, saying only do one asynchronous operation at once. So [`Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) I already have if I switch to Node v0.11 or polyfill it later so all I need to do is hack up a sequential promise mapper and I'll have a much lighter set of code...

So I did, you can get it at [GitHub](https://github.com/forbesmyester/rstyle-sequential-promise-map) or via [npm](https://www.npmjs.com/package/rstyle-sequential-promise-map).

