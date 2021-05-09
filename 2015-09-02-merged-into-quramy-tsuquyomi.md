# Merged Into Quramy/tsuquyomi



In general when I am developing I tend to have unit test results on the right with my code on the left as apposed to having two files open. This means I tend to use `C-^` keystroke a lot, which is jump back to last buffer in VIM.

The last few days I have been investigating [TypeScript](http://www.typescriptlang.org/) following [Tim Perry's LNUG talk](https://twitter.com/LNUGorg/status/636624771862687744) but I found that the [Quramy/tsuquyomi VIM plugin](https://github.com/Quramy/tsuquyomi) overrides the `C-^` keyboard mapping... which is pretty painful for me.

So I submitted a [GitHub pull request](https://github.com/Quramy/tsuquyomi/pull/36) to add an option to disable all key mappings. The feature its elf which is now unbound for me looks really useful, as do the other bindings so I will probably map them later on to different keys if TypeScript goes from a brief investigation into something I end up using long term...

