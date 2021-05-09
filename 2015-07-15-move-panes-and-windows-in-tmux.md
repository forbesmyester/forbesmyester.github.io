# Move Panes and Windows in Tmux



I have a pretty well customized [tmux](https://tmux.github.io) configuration, as do lots of people but there is one thing that I've found difficult to do and isn't in most peoples configuration (that I've seen). This is the ability to move panes between different windows or re-order the windows.

Configuring tmux for moving whole windows around is quite easy as it's a single command in tmux, therefore the standard `command-prompt` method can achieve it.

```
# Moves a whole window to a different number
bind-key M command-prompt -p "reposition window number:" "move-window -t %%"
```

However using the same method to take a pane from window and deposit it in another doesn't work consistently.

```
# Moves a whole window to a different number
bind-key m command-prompt -p "move pane to window:" "join-pane -t '%%'"
```

It will work if there is only one pane within the window, but it fails if there are many saying "Can't join pane to it's own window", which makes no sense to me at all, at least as an error message... My first attempt to fix this involved changing the line to read:

```
# Doesn't work
bind-key m command-prompt -p "move pane to window:" "break-pane ; join-pane -t '%%'"
```

Which seems reasonable but this doesn't work either, I think because it needs to be **a command** template, not multiple commands... I tried a few combinations with no success.

In the end I realised that the VIM/tmux bindings for `C-[hjkl]` were using the tmux run command within the tmux configuration file itself. This is a bit strange as it is actually running a shell command to take a tmux action, within tmux itself... weird but seems to works fine.

So taking this approach I can break the pane, then run the prompt to join it into another window. Not the perfect solution but practical and easy.

```
# Moves an individual pane to another window.
bind-key m run "tmux break-pane ; tmux command-prompt -p \"move pane to window:\" \"join-pane -t '%%'\""
```

