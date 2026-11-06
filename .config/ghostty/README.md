# Ghostty

Neovim uses HackGen Console NF for icons. macOS Option is sent as Alt for Copilot's Alt-key shortcuts.

Personal Ghostty shortcut reference.

## Appearance

The current config keeps Ghostty's own display settings.
Local interactive shells automatically attach to the `main` tmux session, but tmux does not own font size, padding, opacity, blur, or quick terminal behavior.

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

tmux exclusively owns pane splitting:

| Key | Action |
| --- | --- |
| `Ctrl-q r` | Split right |
| `Ctrl-q d` | Split down |

Ghostty's native `Cmd-d` and `Cmd-Shift-d` split shortcuts are disabled to avoid two pane layers.
Set `DOTFILES_SKIP_TMUX=1` before starting a shell when a temporary non-tmux shell is needed.

## Working Directory

New tabs, splits, and windows inherit the current working directory.

Relevant config:

```conf
quick-terminal-position = top
quick-terminal-size = 80%,100%
```
