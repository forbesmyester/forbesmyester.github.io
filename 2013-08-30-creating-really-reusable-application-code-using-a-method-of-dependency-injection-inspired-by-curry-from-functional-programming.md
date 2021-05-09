# "New Release: Curry DI"

inspired by Curry from Functional Programming

In this post I want to look at a method I used for writing decoupled easily reusable code within one of my personal projects using a method inspired by Functional Programming.

## How your code might start...

### routes/user.js

```
var emailSender = new EmailSender( /* SMTP Server */ 'localhost');
var bcrypt = require('bcrypt');

module.exports.register = function(err, req, res, next) {
  // stuff with emailSender and bcrypt.
}
module.exports.login = function(err, req, res, next) {
  // stuff with bcrypt.
}
```

### app.js

```
app.post('/user/register', userRoute.register);
app.post('/user/login', userRoute.login);
```

What is the problem with this? It's not terrible code by any means but when you think about testing it you may run into problems... For testing it you'll probably have to create the database structure for users and registrations and perhaps fill it with data for the login test, how are you going to test that the email was actually sent... I think we need to start considering other methods of creating testable code.

## Starting to Inject Dependencies

I am aware that I could use a Dependency Injection library but this seemed overkill to me at the time so instead I just passed in object with the dependencies as property values. This does basically work fine and allows you to easily mock out the database and email sending, for example. At that moment my code looked something like this...

### routes/user.js

```
module.exports.register = function(err, req, res, dependencies, next) {
  // stuff with dependencies.emailSender and dependencies.bcrypt.
}
module.exports.login = function(err, req, res, dependencies, next) {
  // stuff with dependencies.bcrypt.
}
```

### app.js

```
var dependencies = {
  emailSender: new EmailSender( /* SMTP Server */ 'localhost'),
  bcrypt: require('bcrypt')
};
app.post('/user/register', function(err, req, res, next) {
  return userRoute.register(err, req, res, dependencies, next);
});
app.post('/user/login', function(err, req, res, next) {
  return userRoute.login(err, req, res, dependencies, next);
});
```

As it stands I think this code is perfectly fine though it fiddles with the `err, req, res, next` parameter order of [Express](http://expressjs.com/) which is not ideal. Another thing I don't like about this approach is that if you look at the method signature for userRoute.register you cannot immediately see if it requires `EmailSender`, `brcrypt` or both. I believe the method signature is a very important part of the documentation as it's quite possibly the only part that some developers will ever read. I wanted a method of putting these dependencies into the API of the functions themselves.

## How about using Object Orientation?

```
var userController = new UserController(
  new EmailSender( /* SMTP Server */ 'localhost'),
  require('bcrypt')
);
app.post('/user/register', userController.register);
app.post('/user/login', userController.login);
```

This is probably a bit better, because the dependencies are controlled using the constructor so you can be quite sure you have them all, they have become a part of the API. A side benefit of this is that it has made login and register functions compatible with the Express parameter order.

What are the downsides?

1. We still cannot actually tell whether the `login` function requires EmailSender or not.
2. In a team environment UserController will probably grow to do other things which maybe it should not leading to more and more dependencies being put into the constructor.
3. If you want the `login` feature, you need to take `register` function as well. In short the functions within UserController are becoming more coupled together, at least in the external API, but perhaps internally too. Good luck using the `login` function on another project!

Maybe I don't like this solution much at all!

## Searching for a solution

Having told you the problem I'm now going to go off in a direction which might not seem connected to this issue at all, but I **will** bring you back and apply it again to the original problem.

I recently went to talk by [Hugh FD Jackson](http://hughfdjackson.com/) in which he presented his Curry library. Curry is an idea from [Functional Programming](http://en.wikipedia.org/wiki/Functional_programming) which I have been exploring quite a lot recently. Curry is basically passing in some of the parameters to a function and being returned another function with those parameters already applied, to illustrate this I'm going to steal [Hugh's example](http://hughfdjackson.com/javascript/2013/07/06/why-curry-helps/) directly from his site!

```
var curry = require('curry')                     // Line 1
var add = curry(function(a, b){ return a + b })  // Line 2
var add100 = add(100)                            // Line 3
add100(1) //= 101                                // Line 4
```

How does this work, well on line 2 he makes a curry-able function called `add`. On line 3 he calls that function with only one of the required two parameters, the curry library sees this and instead of trying to return the answer it will return a function which only now expects one argument, because it already has the first. In the last line Hugh calls the returned function with the remaining argument, curry spots this and returns the answer.

## Normal Curry is a possible answer

Thinking about this new technique and applying it to our problem above we could write our code like the following:

### routes/user.js

```
module.exports.register = function(emailSender, bcrypt, err, req, res, next) { }
module.exports.login = function(err, req, res, next) { }
```

### app.js

```
var emailSender = curry(require('email-sender'))('localhost'); // curried this!
var bcrypt = require('bcrypt');
app.post('/user/register', curry(userRoute.register)(emailSender, bcrypt));
app.post('/user/login', userRoute.login);
```

Is this better? I think so. It will likely encourage the functions within userRoute to be less coupled together as they are now not part of an instance. A problem with this approach is that the userRoute API is no longer unified, which we have somewhat dealt with by currying, but we're still exposing `app.js` to those different API's and possible ripple effects on a function by function basis. I also dislike the fact that `err` is no longer the first parameter for userRoute.register. It now seems to me that currying has become a requirement for having a sane API for these functions, which I dislike.

## The Answer (or at least my answer anyway)

Perhaps we could have loosely coupled functions, a centralized list of dependencies and distinct function parameters documenting those dependencies. How about something like this?

### routes/user.js

```
module.exports.register = function(err, req, res, bcrypt, emailSender, db, next) { }
module.exports.login = function(err, req, res, memcache, db, next) { }
```

### app.js

```
var curryDi = require('curry-di');
var dependencies = {
  emailSender: var emailSender = curry(require('email-sender'))('localhost'),
  bcrypt: require('bcrypt'),
  db: db,
  memcacheApi: memcacheApi
};

// The return value of curryDi(dependencies, ...) is a function with the
// signature function(err, req, res, next) as all other parameters have
// been matched to the dependences object.
app.post('/user/register', curryDi(dependencies, userRoute.register));
app.post('/user/login', curryDi(dependencies, userRoute.login));
```

What's happening here? Well whereas curry will effectively pre-apply parameters from the start of the parameters, curryDi will pre-apply parameters by **matching** the **properties/dependencies** from the object **with the function parameters by name**. This solution has the following advantages over where we started.

 1. We can see immediately that `userRoute.register` sends emails, encrypts passwords and accesses user records from the database while `userRoute.login` accesses user records from the database and probably stores sessions within Memcache (presuming).
 2. By using `curry-di.js` we have effectively unified the API which `app.js` consumes.
 3. The API for userRoute also is much more like what you would expect to find for code in Node.js, with err being the first parameter and the callback being the last.
 4. The `req, res, next` parameter order is what you will expect to find in Express.
 5. Both functions are easy to test by making mocks of the individual parameters.
 6. Because the functions are just functions they are completely independent and can be used on any project, with or without the use of `curry-di`.

Hugh FD Jackson's excellent curry library can be found on [GitHub](https://github.com/dominictarr/curry) and [also installed via npm](https://npmjs.org/package/curry).

You can download my [`curry-di`](https://github.com/forbesmyester/curry-di) mini library from my [GitHub Account](https://github.com/forbesmyester) or using [npm](https://npmjs.org/).

At a meeting of the London Software Craftmanship Community I did a talk based on this blog post that received some favourable coments [on Meetup](http://www.meetup.com/london-software-craftsmanship/events/138960052/), really nice as it was my first time at a Round Table meeting

Tags: functional-programming, node
