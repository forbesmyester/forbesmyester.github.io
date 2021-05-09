# Registering a Package on Bower

Up until now I have only wanted to use me\_map\_reduce in [Node.js](http://nodejs.org/), but today I wanted to use that functionality on a website too.

This proved to be a very easy exercise even though I have not done it before or even done any of the individual steps!

The instructions given on [Bower.io](http://bower.io/) tell me that:

- There must be a valid manifest JSON in the current working directory.
- Your package should use semver Git tags.
- Your package must be available at a Git endpoint (e.g., GitHub); remember to push your Git tags!

## There must be a valid manifest JSON in the current working directory.

Starting right at the start, what is a **manifest file**... I try hitting `ctrl-f` on the page and search for the word 'manifest' but that is the only reference. Doing some [Googling](http://www.google.com) I found [an article on StackOverflow](http://stackoverflow.com/questions/18477306/what-is-the-recommended-manifest-json-format-for-bower-packages) where the recommended answer tells that that I need a `bower.json` file or a `component.json` file and "Keep using `bower init`, it'll do the right thing for you!". Searching on the page reveals that there is a section called "Defining a Package" referencing `bower.json` and that Some of the Bower components I have installed already have a `bower.json`. It seems that `bower.json` **is** the manifest file, makes sense but it always pays to be sure.

Running `bower init` guides me through the following wizard:

```
$ bower init
[?] name: me_map_reduce
[?] version: 0.9.0
[?] description: MongoDB style Map/Reduce functionality for JS
[?] main file: lib/me_map_reduce.js
[?] keywords: map, reduce, map/reduce
[?] authors: Matthew Forrester <matt@keyboardwritescode.com>
[?] license: BSD-style
[?] homepage: https://github.com/forbesmyester/me_map_reduce
[?] set currently installed components as dependencies? Yes
[?] add commonly ignored files to ignore list? Yes
[?] would you like to mark this package as private which prevents it from being accidentally publis[?] would you like to mark this package as private which prevents it from being accidentally published to the registry? No
```

Pretty handy!

## Your package should use semver Git tags.

[A page describing Semver](http://semver.org/) is helpfully hyperlinked from the Bower.io homepage and it seems to just be in the form `[MAJOR].[MINOR].[PATCH]`. I elect to use version `0.9.0` because I cannot see myself ever added extra features to [me\_map\_reduce](https://github.com/forbesmyester/me_map_reduce) but the code has probably got near zero use, so could have bugs and I'd not like to call potentially buggy code version 1.0.0.

How to create a Git Tag is referenced in the (Git Book)[http://git-scm.com/book/en/Git-Basics-Tagging] and is pretty easy. The example gives the command `git tag -a v1.4 -m 'my version 1.4` to create a tag, but that raises another question, does a semver tag include a 'v'... [StackOverflow gives an answer](http://stackoverflow.com/questions/16542000/can-i-manage-bower-versioning-via-git-tags-only#comment26621340_16560493) which says they do not. So I commit my new `bower.json` (created by `bower init`) and then create the tag using the following command:

```
$ git tag -a 0.9.0 -m 'Version 0.9.0'
```

## Your package must be available at a Git endpoint (e.g., GitHub); remember to push your Git tags!

I need to push my tag...

The [Git Book](http://git-scm.com/book/en/Git-Basics-Tagging) tells me that to push a tag all I need to do is `git push origin [tagname]` or `git push --tags` to push all tags... I elect to push all my tags as it's first Tag I have ever created:

```
git push --tags
```

## All Set - Time To Publish!

Jumping back to [the Bower.io registering packages section](http://bower.io/#registering-packages) it says that `bower register <my-package-name> <git-endpoint>` will register my package. So...

```
$ bower register me_map_reduce git@github.com:forbesmyester/me_map_reduce.git
```

Testing my Bower package using `bower install --save me_map_reduce` where I wanted to use the code installed me\_map\_reduce perfectly.

