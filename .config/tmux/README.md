# tmux

tmux owns pane splitting for this dotfiles setup.
Ghostty and WezTerm are terminal hosts; they do not own project pane layout.
The real config is `.config/tmux/tmux.conf`.

## Start Or Reattach

```sh
tmux new -A -s main
```

## Prefix

The tmux prefix is `Ctrl-q`.

| Key        | Action                           |
| ---------- | -------------------------------- |
| `Ctrl-q r` | Split right                      |
| `Ctrl-q d` | Split down                       |
| `Ctrl-q h` | Move to left pane                |
| `Ctrl-q j` | Move to lower pane               |
| `Ctrl-q k` | Move to upper pane               |
| `Ctrl-q l` | Move to right pane               |
| `Ctrl-q z` | Toggle pane zoom                 |
| `Ctrl-q x` | Close pane                       |
| `Ctrl-q c` | New window                       |
| `Ctrl-q n` | Next window                      |
| `Ctrl-q p` | Previous window                  |
| `Ctrl-q s` | Session, window, and pane picker |
| `Ctrl-q D` | Detach                           |
| `Ctrl-q R` | Reload config                    |

New panes and windows inherit the current pane's working directory.
The tmux status line is disabled; Ghostty or WezTerm owns colors, opacity, blur, fonts, and other appearance settings.
tmux still advertises RGB support to apps inside panes so truecolor output survives the tmux hop.
