Moving Blog to BashBlog

I have Blog files stored in Markdown which I pre-process using [remark](https://github.com/remarkjs/remark) and some [custom](https://github.com/forbesmyester/remark-unixpipe) [plugins](https://github.com/forbesmyester/remark-copy-code-meta-hash-up).

They all originally were from Jekyll and then Pelican but I've become disatisfied with them so I wanted to move to [BashBlog](https://github.com/cfenollosa/bashblog) because I want something simple where the files are just pure markdown.

There are two jobs in this tasks

## Job 1: Change Front Matter into a H1 and `Tags: `

### The one off...

Jekyll has content stored as Markdown with Front Matter above which looks like the following:

    ---
    title:        Code In PostgreSQL: Combining data from multiple tables with INNER JOIN
    date:         2019-03-04 21:00:20
    tags:         code-in-postgresql, javascript, postgresql
    category      postgresql
    ---

    Welcome to my post, the H1 will automatically be written by the title in my front matter.

    ## This is a H2

I need to convert this into

    # This is my real title

    And I have content

    ## And other headers

    Tags: but, i-have, other-tags-too

This conversion is relatively for a one off via an AWK script

```javascript file=content-assets/2021-05-04-moving-blog-to-bashblog/convert_post.awk
```

The basic idea is that

 1. It pulls out the `tags:`, `category:` and `title:`
 2. If the title is defined and you hit a line that begins with `---`
 3. Print out the H1 tag (title)
 4. If the title has been printed out, print out the current line
 5. Finally print out the `category:` and `tags:` as tags.

You can run this with `cat your_jekyll.md | awk -f convert_post.awk` and it will print the BashBlog output to STDOUT.

### Every file

To do this for every file is relatively simple with GNU Parallel

```bash
find 2*.md | parallel mv {} {}.x
find 2*.md.x | parallel cat {} '|' awk -f convert_post.awk '>' {.}
rm *.x
```

## Job 2: File names with multiple periods (.)

function multi_dot() {
    FILENAME="$1"
    FILENAME_NO_EXT="$(echo "$FILENAME" | sed 's/\.md$//')"
    NEW_FILENAME="$(echo "$FILENAME_NO_EXT" | sed 's/\./_/g').md"
    mv "$FILENAME" "$NEW_FILENAME"
}
export -f multi_dot

find *.*.md | parallel multi_dot 

## Job 3: Correct Dates

Given I have files like [2019-07-24-ndjson-env.md](2019-07-24-ndjson-env.md) which encode the date it shouldn't be too hard, but BashBlog wants to store the date within a comment of the HTML file that looks like `<!-- bashblog_timestamp: #202105031115.27# -->`.

If I want to import my data I can copy the markdown file into the working directory and run `bb.sh edit MARKDOWN_FILE.md` which will open up my `$EDITOR` and, upon save, generate a HTML file with the timestamp of `$(date)`.

To do a mass import I will need to do some thinking:

## Generating the HTML for blog post

if I run `bb.sh edit 2019-07-24-ndjson-env.md` and there is no `2019-07-24-ndjson-env.html` BashBlog will exit with the status code 255 and the following output:

    $ ./bb.sh edit 2019-07-24-ndjson-env.md
    Can't edit post 2019-07-24-ndjson-env.html, did you mean to use "bb.sh.sh post <draft_file>"?

This is easily solved by a `touch 2019-07-24-ndjson-env` and then re-running:

    $ touch  2019-07-24-ndjson-env.html
    $ bb.sh edit 2019-07-24-ndjson-env.md
    MARKDOWN: /home/fozz/Projects/plain-text-blog/markdown
    Posted 2019-07-24-ndjson-env.html
    Rebuilding tag pages .
    Rebuilding the index ........
    Creating an index page with all the posts ........
    Creating an index page with all the tags ...
    Making RSS ........

Which is a good process, but I don't want to re-open my `$EDITOR` for every post...

## The fake `$EDITOR`

If BashBlog always uses `$EDITOR` to allow you to edit before a post, why not set `$EDITOR` to something which will take the parameter of a file, will return a exit code of 0, but not be interactive... something like `echo`.

So now our `bb.sh edit ...` command now looks like `env EDITOR=echo bb.sh edit 2019-07-24-ndjson.env.md`

## The Date

Having done all this BashBlog will still think the date of the post is now, because it has no logic to read the date from the filename, only from the `bashblog_timestamp` comment within the HTML file (falling back to `$(date)`);

The following command will use `sed` to replace the date:

    sed 's/\(<!-- bashblog_timestamp: #\).*\(# -->\)/\1YOUDATE\2/' -i 2019-07-24-ndjson-env.html

## One Blog Post

To restore just one Blog post we would need to run the following commands:

    DATE="$(echo "2019-07-24-ndjson-env.md" | cut -d '-' -f 1,2,3 | sed 's/\-//g')0830.01"
    touch "2019-07-24-ndjson-env.html"
    env EDITOR=echo bb.sh edit "2019-07-24-ndjson-env.md"
    sed 's/\(<!-- bashblog_timestamp: #\).*\(# -->\)/\1'"$DATE"'\2/' -i "2019-07-24-ndjson-env.html"

But after this the post will display the current date within the file and if you `bb.sh edit 2019-07-24-ndjson-env.md` it will reset the date still, because for `bb.sh edit` the date of the file still takes precedence.

The clue to fixing this is in the changelog, it says:

> 2.7 Store post date on a comment in the html file (#96).
> On rebuild, the post date will be synchronised between comment date and file date, with precedence for comment date.

So all we need to do is run `bb.sh rebuild` and it changes the date of the file to the `bashblog_timestamp` and upates the text of the HTML to the correct date.

## Many posts

This is all great. But I need to update a lot of blog posts so I'll turn to my old friend GNU parallel:

First putting the above into script called `publish-dated-md`:

```unixpipe cat publish-dated-md | wrap-as-lang bash
```

And then running it on all the files:

```bash
find *.md | grep '^[0-9]\{4\}' | parallel -j1 --halt now,fail=1 publish-dated-md {}
bb.sh rebuild
```

Which pretty much does the same as in the "One Blog Post" header, but using [GNU Parallel](https://www.gnu.org/software/parallel/) to process all the files and then runs a `bb.sh rebuild` at the end to clean it all up.

Tags: blogging, bashblog, bash, gnu-parallel
