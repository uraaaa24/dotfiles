# dotfiles

Personal notes and quick re-setup steps.

## Purpose

- Keep setup fast and repeatable
- Prefer small, clear defaults over heavy customization
- Make maintenance easy with `task`

## Overview

- `.config/git` Git defaults and global ignore
- `.config/ghostty` Ghostty config
- `.config/lazygit` LazyGit config
- `.config/mise` mise runtime defaults
- `.config/nvim` Neovim config
- `.config/tmux` tmux session and pane config
- `.config/wezterm` WezTerm config
- `.config/zsh` zsh and Powerlevel10k config
- `Brewfile` Homebrew bundle
- `.editorconfig` shared editor defaults
- `Taskfile.yml` task runner

## Layout Principles

- Keep tracked configuration in this repo and install it with symlinks.
- Keep machine-local secrets, tokens, caches, and one-off overrides out of git.
- Keep app configuration bodies under `.config/`; root files are reserved for repository operations, documentation, and conventional repo-level config.
- Keep `Taskfile.yml` as the single command interface for setup and maintenance.
- Make setup idempotent: rerunning tasks should converge on the same state.

## Setup (local)

```sh
task setup
```

Preview symlink changes before touching `$HOME`:

```sh
task link:dry-run
```

## Common tasks

### Task list

- `task setup` Full setup (link + check + brew + mise + AI CLIs)
- `task link` Link dotfiles
- `task link:dry-run` Preview symlink changes
- `task check` Run lightweight repository checks
- `task doctor` Show local development environment status
- `task brew:bootstrap` Install Homebrew if missing
- `task brew:bundle` Install packages from `Brewfile`
- `task brew:update` Update Homebrew packages
- `task brew:doctor` Run Homebrew diagnostics
- `task mise:install` Install runtimes via mise
- `task ai:setup` Install AI CLIs (Copilot, Codex, Gemini)
- `task nvim:sync` Sync Neovim plugins

`task link` backs up an existing non-matching path next to the original before replacing it with a dotfiles symlink.
For example:

```sh
~/.config/example.backup.<timestamp>
```

`task check` validates required config paths, Taskfile readability, zsh syntax, mise config readability, and optional app checks when the tools are installed:
`stylua --check .config/nvim`, WezTerm key binding validation, and Ghostty config validation.

## LazyGit

LazyGit uses a darker gray selected-line background so focused rows stay visible without washing out file diffs.
On macOS, `task link` links this repo's `.config/lazygit` to:

```sh
~/Library/Application Support/lazygit
```

## Shell And Runtimes

Runtime versions are managed by mise and pinned by major or minor series in `.config/mise/config.toml`.
This avoids unexpected major upgrades while still allowing patch updates within the selected series.

zsh initializes mise and direnv.
Use project-local `.envrc` files for per-project environment variables or runtime activation such as:

```sh
use mise
```

Review an `.envrc` before running `direnv allow`.

## Docker

Docker Desktop is not part of the standard setup.
Colima and the Docker CLI are installed by Homebrew so projects can use containers without Docker Desktop.
Starting, stopping, and configuring Colima is left to each project or machine-local workflow.

## Pane Splits

Pane splitting is handled by tmux when tmux is running.
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

When tmux is not running, Ghostty and WezTerm provide native pane splits with matching directions:

| Key | Action |
| --- | --- |
| `Cmd-d` | Split right |
| `Cmd-Shift-d` | Split down |

### Notes

- Reflect new changes here
- When unsure, re-check the Taskfile
