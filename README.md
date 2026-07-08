# dotfiles

Personal notes and quick re-setup steps.

## Purpose

- Keep setup fast and repeatable
- Prefer small, clear defaults over heavy customization
- Make maintenance easy with `task`

## Overview

- `.config/nvim` Neovim config
- `.config/git` Git defaults and global ignore
- `.config/ghostty` Ghostty config
- `.config/mise` mise runtime defaults
- `.config/tmux` tmux session and pane config
- `.config/wezterm` WezTerm config
- `.zshrc` shell config
- `Brewfile` dependencies
- `Taskfile.yml` task runner
- `.editorconfig` editor defaults

## Setup (local)

```sh
task setup
```

## Common tasks

### Task list

- `task setup` Full setup (link + brew + mise)
- `task link` Link dotfiles
- `task brew:bootstrap` Install Homebrew if missing
- `task brew:bundle` Install packages from Brewfile
- `task brew:update` Update Homebrew packages
- `task brew:doctor` Run Homebrew diagnostics
- `task mise:install` Install runtimes via mise
- `task ai:setup` Install AI CLIs (Copilot, Codex, Gemini)
- `task nvim:sync` Sync Neovim plugins

`task link` backs up an existing non-symlink path before replacing it with a dotfiles symlink.
For example, an existing `~/.config/ghostty` becomes `~/.config/ghostty.backup.<timestamp>`.

## tmux

Pane splitting is handled by tmux, not by Ghostty or WezTerm.
The main config lives at `.config/tmux/tmux.conf`.
If you need to start tmux manually, use:

```sh
tmux new -A -s main
```

tmux uses `Ctrl-q` as its prefix.
tmux is kept to pane/session operations only. Its status line is disabled, and Ghostty or WezTerm owns colors, opacity, blur, fonts, and other appearance settings.
tmux still passes RGB color support through to apps inside panes so terminal output keeps its truecolor palette.

| Key | Action |
| --- | --- |
| `Ctrl-q r` | Split right |
| `Ctrl-q d` | Split down |
| `Ctrl-q h/j/k/l` | Move between panes |
| `Ctrl-q z` | Toggle pane zoom |
| `Ctrl-q x` | Close pane |
| `Ctrl-q c` | New window |
| `Ctrl-q n` | Next window |
| `Ctrl-q p` | Previous window |
| `Ctrl-q s` | Session/window/pane picker |
| `Ctrl-q D` | Detach |
| `Ctrl-q R` | Reload `.config/tmux/tmux.conf` |

### Notes

- Reflect new changes here
- When unsure, re-check the Taskfile
