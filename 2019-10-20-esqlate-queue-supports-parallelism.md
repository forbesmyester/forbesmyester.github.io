# EsqlateQueue now supports parallelism!


Previously I wrote about [EsqlateQueue](./2019-09-16-esqlate-queue.html), which is a mini library allowing a queue of work to be set aside and worked on out-of-process. This is useful for things which could be IO intensive and take a while, but don't take a lot of CPU time.

Because this was the first version it just took items off the queue one by one for processing.

This is still useful, but perhaps it might be more useful to be able to do these things in parallel?

The new version, version 2 is built upon [async](https://caolan.github.io/async/v3/) and does parallelism up to the amount specified!

The API is 100% compatible, just an extra optional (default 1) parameter to say how parallel you want it.

### Installation

To install, use NPM:

    npm install esqlate-queue

### License

The code is licensed under MIT.

You can find this project at [GitHub](https://github.com/forbesmyester/esqlate-queue).

Tags: typescript, nodejs, parallelism
