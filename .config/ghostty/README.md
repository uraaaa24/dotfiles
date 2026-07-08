# Ghostty

Personal Ghostty shortcut reference.

## Appearance

The current config keeps Ghostty's own display settings.
tmux only starts inside the terminal; it does not own font size, padding, opacity, blur, or quick terminal behavior.

| Setting | Value |
| --- | --- |
| Font size | `14` |
| Background | `#181616` |
| Foreground | `#c5c9c5` |
| Background opacity | `0.90` |
| Background blur | `20` |
| Padding | `8` |
| Quick terminal | `Cmd-\`` |
| macOS titlebar | Transparent |
| TERM | `xterm-ghostty` |

## Key Bindings

### Tabs And Windows

| Key | Action |
| --- | --- |
| `Cmd-\`` | Toggle quick terminal |
| `Shift-Enter` | Insert newline |

### Splits

Splits are delegated to tmux.
Ghostty keeps tab/window shortcuts only, and `Ctrl-q` is reserved for the tmux prefix.
Open Ghostty, then start tmux manually with `tmux new -A -s main` and split panes with `Ctrl-q r` and `Ctrl-q d`.

## Working Directory

New tabs, splits, and windows inherit the current working directory.

Relevant config:

```conf
quick-terminal-position = top
quick-terminal-size = 80%,100%
```
