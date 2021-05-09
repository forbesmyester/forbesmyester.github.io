# Require.JS Shims - Working with Non AMD code


I'm pretty much settled on using [Require.JS](http://requirejs.org/) for loading front end JavaScript code because:

1. I like the way it allows me to precisely control the libraries that are available within a JavaScript file.
2. Gives me the ability to write small re-usable libraries, thus aiding re-usability.
3. Avoids polluting the global namespace.
4. My JavaScript can be easily minified.

The only problem is that it seems that there are lots of great libraries that are not yet using AMD...

So I'm coding along quite happily and what I want to do is take a data structure and convert it into HTML. Now I know I could use some form of micro template but in this situation I'm not really substituting data into HTML but representing the data I have as a HTML structure, which is a subtle but important difference.

Recently I've been looking at Functional Programming a lot and have come across a library called [Hiccup](https://github.com/weavejester/hiccup) which does exactly the job I need but it's wrote for Clojure. As the shortest introduction possible to a library it would take the Clojure equivalent of:

```
[span {"class": "foo"} "bar"]
```

and return the HTML data structure:

```
<span class="foo">bar</span>
```

I set about finding a library that does something similar for JavaScript and in the end I found [Singult](https://github.com/lynaghk/singult).

The major downside of Singult for me is that it adds a global under the name `singult`. I don't like the idea of fiddling with source files or maintaining my own Require.JS version in a GitHub fork but I still need a way to live with their code in my new shiny AMD world.

I had previously stumbled upon the [use.js](https://github.com/tbranyen/use.js) library which allows you to shim non AMD code into AMD quite easily but it now seems that the new way to do this is to use [Require.JS shims](http://requirejs.org/docs/api.html#config-shim)

If you're using Require.JS your HTML will probably include something like the following:

```
<script data-main="/js/main" src="/vendor-bower/requirejs/require.js"></script>
```

Add shim to your Require.JS configuration stored in your "main.js" file:

```
require.config({
    baseUrl: '/js',
    paths: {
        singult: "/vendor/github.com/lynaghk/singult/singult.min"
    },
    shim: {
        singult: {
            deps: [],
            exports: 'singult'
        }
    }
});
```

In this situation I am telling Require.JS where to find Singult in the "paths" section and also telling it that it has no dependencies (`deps`) and that `singult` should be exported from the global namespace (`exports`).

To use the library all you need to do is include the key from "paths" and your library will come in as if it were a proper AMD library:

```
define(['singult'], function(singult) {
    // code
});
```

It's not the perfect solution because it does leave the global available, but this does at least mean that you can centrally configure the dependencies and write your code using modern development practices.

