# Ghostty

Personal Ghostty shortcut reference.

## Appearance

The current config keeps Ghostty's own display settings.
tmux only starts inside the terminal; it does not own font size, padding, opacity, blur, or quick terminal behavior.

| Setting | Value |
| --- | --- |
| Font size | `16` |
| Background | `#181616` |
| Foreground | `#c5c9c5` |
| Background opacity | `0.80` |
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

Use tmux splits with `Ctrl-q r` and `Ctrl-q d` when tmux is running.
When tmux is not running, Ghostty provides native splits with matching directions:

| Key | Action |
| --- | --- |
| `Cmd-d` | Split right |
| `Cmd-Shift-d` | Split down |

## Working Directory

New tabs, splits, and windows inherit the current working directory.

Relevant config:

```conf
quick-terminal-position = top
quick-terminal-size = 80%,100%
```
