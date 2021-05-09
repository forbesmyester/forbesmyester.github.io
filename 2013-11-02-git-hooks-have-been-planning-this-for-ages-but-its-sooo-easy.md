# Git Hooks... Have been planning this for ages but it's sooo easy!



Currently when I get home from work and I want a bit of a change I'll do a bit of work learning Clojure, which at the moment is writing a script to generate HTML photo albums from a directory structure with images... I'm looking forward to getting it working and then [continuing to read, learning new tricks](http://pragprog.com/book/shcloj2/programming-clojure) and slowly improving it. Right now though it's still not functioning, so watch my [GitHub Account](https://github.com/forbesmyester) for some really bad Clojure code appearing soon!

Aside from the learning Clojure aspect I want to store my photo's in [Git Annex](http://git-annex.branchable.com/) so I can share the photo albums seemlessly with my wife and take good backups of the pictures AND data. Sharing with the ability to take proper (sane) backups seem to be features lacking for most Linux photo software I've found...

My plan for this is to automate running the script using git hooks which will be executed after `git pull` and `git commit` but in the meantime I wanted to add a pre-commit hook to run JSHint before commiting changes to my [SyncIt](https://github.com/forbesmyester/SyncIt) project. So... how to do this...

Apparently Git hooks will not allow the commit to proceed when a [hook exits with a non-zero error code](http://git-scm.com/book/en/Customizing-Git-Git-Hooks#Client-Side-Hooks) which seems correct with UNIX style philosophies. So now I know what I want to achieve in my script, which will eventually be a hook... This is what I came up with...

```
#!/bin/sh

# == JSHint ====================================================================
JSHINT='node_modules/.bin/jshint'
ERROR=false
for jsfile in $(git diff-index --name-only --cached HEAD -- | grep '\.js$'); do
    if $JSHINT $jsfile 2>&1 | grep -i 'line'; then
        ERROR=true
    fi
done

if $ERROR ; then
    exit 1
fi

# == Everything OK so Exit  ====================================================
exit 0
```

This will go through all files which have staged in Git and have a ".js" extension and run JSHint on them. If the message that JSHint returns includes "line" it will set the ERROR flag and will eventually exit with a non-zero error code (1).

Putting this in .git/hooks/pre-commit and making sure it's executable ( `chmod +x .git/hooks/pre-commit` ) will make sure it's ran before every commit.

So I'm Feeling good because I've done something I really should have done ages ago and also some research for my gallery project too :-)

