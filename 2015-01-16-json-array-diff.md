# New Release: json-array-diff



For most of my working life I've been doing RDD (refresh driven development) but in the last 3-4 years I've been using more and more TDD. It's got to the point that pretty much all functionality new that I write is written using TDD, life is sooooooo much better but recently I've found myself staring at big JSON documents trying to figure out why `expected` is not equal to `result` four levels deep. This is not fun and it's also not a good use of time so I decided that I needed to come up with a solution...

I created a little bash script called `json-array-diff`. The code itself is shown below:

```
#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
JSON=$(cat $input | grep 'DIFFTHIS: ' | sed 's/.*DIFFTHIS\:\s*\[/[/')

JSONA=$(echo $JSON | jq -S ".[0]" > /tmp/${USER}-a.json)
JSONB=$(echo $JSON | jq -S ".[1]" > /tmp/${USER}-b.json)

meld /tmp/${USER}-a.json /tmp/${USER}-b.json
```

This horrid bash code takes the input from STDIN and looks for the text 'DIFFTHIS: ' within it and then uses `sed` to remove it... as long as the next non-whitespace character is a '['. Why before a '['? Well the text from 'DIFFTHIS: ' until the end of the line is intended to be a JSON document including the expected and actual results. Next we use `jq` to rip the first and second elements from that array and write them to temporary files in `/tmp` and finally use `meld` (my preferred diffing program) to show the differences between the two files.

This give me the not-perfect but far better workflow of:

1. Write a new test.
2. It fails.
3. Hack away on code till I get something that looks like it might just work.
4. It spews out 4K of JSON data which I can't diff with my eyes.
5. Swear.
6. Add the text snippet `console.log("DIFFTHIS: ", JSON.stringify([expected, result]))` to my test just above the failing line.
7. Re-run test
8. `meld` pops up making it super easy for me to spot the error.
9. Fix the code, it's easy now I know what I messed up!

You can download the script [https://github.com/forbesmyester/provisioning-common/blob/master/roles/terminal\_developer/files/scripts/json-array-diff](from%20GitHub) hope it stops you staring :-)

