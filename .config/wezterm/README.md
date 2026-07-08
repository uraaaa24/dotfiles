# WezTerm

Personal WezTerm shortcut reference.

## Role

WezTerm is used as a terminal host only.
Pane splitting is delegated to tmux so the same workspace can be restored from Ghostty or WezTerm.
Open WezTerm, start tmux manually with `tmux new -A -s main`, then use tmux for panes:

| Key | Action |
| --- | --- |
| `Ctrl-q r` | Split right |
| `Ctrl-q d` | Split down |
| `Ctrl-q h` | Move to left pane |
| `Ctrl-q j` | Move to lower pane |
| `Ctrl-q k` | Move to upper pane |
| `Ctrl-q l` | Move to right pane |
| `Ctrl-q z` | Toggle pane zoom |
| `Ctrl-q x` | Close pane |
| `Ctrl-q D` | Detach |

## WezTerm Shortcuts

| Key | Action |
| --- | --- |
| `Cmd-1` to `Cmd-9` | Switch tabs |
| `Cmd-t` | New tab |
| `Cmd-w` | Close tab |
| `Cmd-n` | New window |
| `Cmd-r` | Reload config |
| `Alt-Enter` | Toggle fullscreen |
