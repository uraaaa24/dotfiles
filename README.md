# dotfiles

Personal notes and quick re-setup steps.

## Purpose

- Keep setup fast and repeatable
- Prefer small, clear defaults over heavy customization
- Make maintenance easy with `task`

## Overview

- `.config/git` Git defaults and global ignore
- `.config/ai/skills` shared Agent Skills for Codex and Claude Code
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

Requires Apple Silicon macOS, Xcode Command Line Tools (`xcode-select --install`), and the `task` CLI. Setup installs Homebrew packages before linking configs, then installs mise runtimes, activates them for npm-based CLI installation, and runs checks. Re-running setup preserves matching symlinks and existing CLI installations.

Preview symlink changes before touching `$HOME`:

```sh
task link:dry-run
```

## Common tasks

### Task list

- `task setup` Full setup (Homebrew packages + links + mise + AI CLIs + Commitizen + checks)
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
- `task nvim:sync` Install and update Neovim plugins with `vim.pack`
- `task nvim:tools` Install Commitizen for the LazyGit shortcut

`task link` backs up an existing non-matching path next to the original before replacing it with a dotfiles symlink.
For example:

```sh
~/.config/example.backup.<timestamp>
```

## Agent Skills

Agent Skills live under `.config/ai/skills`. `task link` discovers every directory containing `SKILL.md` and links it to both clients automatically:

```text
~/.codex/skills/<skill-name> -> ~/.dotfiles/.config/ai/skills/<skill-name>
~/.claude/skills/<skill-name> -> ~/.dotfiles/.config/ai/skills/<skill-name>
```

Adding another Skill does not require changing `Taskfile.yml`.

`task check` validates required config paths, Taskfile readability, all three zsh files, mise config readability, and optional app checks when the tools are installed:
`stylua --check .config/nvim`, the 53-case Oil Git parser check, WezTerm key binding validation, and Ghostty validation against this repository’s config.

## Neovim

The editor uses Neovim 0.12+, built-in `vim.pack`, and Kanagawa Wave. Plugin revisions are tracked in `.config/nvim/nvim-pack-lock.json`. `task nvim:sync` updates plugins and this lockfile; Mason installs language tools when Neovim starts. `git-delta` supplies LazyGit's diff renderer. Keymaps and daily use are documented in `.config/nvim/README.md`.

## LazyGit

LazyGit uses a darker gray selected-line background so focused rows stay visible without washing out file diffs.
Neovim opens LazyGit with `;g`. Git diffs use `delta`; automatic fetch and mouse input are disabled.
The file panel's `C` command runs Commitizen. `task link` links `.config/git/.czrc` to `~/.czrc`; `task nvim:tools` installs its CLI.
On macOS, `task link` links this repo's `.config/lazygit` to:

```sh
~/Library/Application Support/lazygit
```

## Shell And Runtimes

Runtime versions, including pnpm and Terraform, are managed by mise and pinned by major or minor series in `.config/mise/config.toml`. The Brewfile does not install a second copy of these tools.
This avoids unexpected major upgrades while still allowing patch updates within the selected series.

`task link` manages both `~/.zprofile` and `~/.zshrc`; login shells load `.zshrc` once through zsh's normal startup sequence.
Powerlevel10k is installed by Homebrew and loaded from its `share/powerlevel10k` directory; a separate `~/powerlevel10k` checkout is not needed.
zsh initializes mise, direnv, and Vite Plus when `~/.vite-plus/env` exists.
Interactive local shells opened by Ghostty or WezTerm automatically attach to the `main` tmux session.
The tmux check runs before Powerlevel10k Instant Prompt so its temporary terminal redirection cannot affect the TTY guard.
Set `DOTFILES_SKIP_TMUX=1` before starting a shell to bypass auto-attach temporarily.
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

Pane and session management is handled exclusively by tmux.
The main config lives at `.config/tmux/tmux.conf`.
Ghostty and WezTerm automatically attach local interactive shells to the `main` session.
To attach manually from another terminal, use:

```sh
tmux new -A -s main
```

tmux uses `Ctrl-q` as its prefix.
tmux is kept to pane/session operations only. Its status line appears at the top with window names. Ghostty or WezTerm owns opacity, blur, fonts, and terminal appearance.
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

Ghostty's and WezTerm's native split shortcuts are disabled so pane ownership and shortcuts do not change between terminal states.

### Notes

- Reflect new changes here
- When unsure, re-check the Taskfile
