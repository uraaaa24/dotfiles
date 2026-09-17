# WezTerm

Personal WezTerm shortcut reference.

## Role

Local interactive shells in WezTerm automatically attach to the `main` tmux session.
tmux exclusively owns pane and session management:

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

WezTerm's native `Cmd-d` and `Cmd-Shift-d` split shortcuts are disabled to avoid two pane layers.
Set `DOTFILES_SKIP_TMUX=1` before starting a shell when a temporary non-tmux shell is needed.

## WezTerm Shortcuts

| Key | Action |
| --- | --- |
| `Cmd-1` to `Cmd-9` | Switch tabs |
| `Cmd-t` | New tab |
| `Cmd-w` | Close tab |
| `Cmd-n` | New window |
| `Cmd-r` | Reload config |
| `Alt-Enter` | Toggle fullscreen |
