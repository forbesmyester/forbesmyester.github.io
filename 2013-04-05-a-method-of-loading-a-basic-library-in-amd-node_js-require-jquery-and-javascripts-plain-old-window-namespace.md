# A method of loading a basic library in AMD, Node.JS require(), jQuery and Javascript's


plain old window namespace...

Using a combination of [IIFE](http://benalman.com/news/2010/11/immediately-invoked-function-expression/) and [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) I have created a method of writing libraries that is compatible with jQuery, Node.js require(), Dojo AMD and plain old Javascript window. This is available via a public [GitHub Gist](https://gist.github.com/forbesmyester/5293746)

After creating this Gist I decided that I had either:

- Re-implemented something that already existed, which would not be so helpful, but I did look around a lot before doing so.
- Invented something really cool ( hoping, but not that likely as this seems like an obvious and easy piece of code to write ).

So I [posted on StackOverflow](http://stackoverflow.com/questions/15815460/is-there-already-pre-existing-code-for-supporting-dojo-amd-nodejs-require-and-b) to try and find out. It turns out that this approach is not really unique and the term I needed was "UMD" (Universal Module Definition). There is a project for collating these [in a GitHub repository](https://github.com/umdjs/umd). I will go about reading the code from that Repository and will see if it is worth me contributing the code I created to that project.

Either way, I learnt a term, created some pretty good code (even if now not useful) and hopefully helped others by posting on StackOverflow, so in some ways that's pretty successful

