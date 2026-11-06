# dotfiles

Personal notes and quick re-setup steps.

## Purpose

- Keep setup fast and repeatable
- Prefer small, clear defaults over heavy customization
- Make maintenance easy with `task`

## Overview

- `.config/git` Git defaults and global ignore
- `.config/ai/AGENTS.md` shared personal instructions for Codex and Claude Code
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
- `task nvim:sync` Install and update Neovim plugins with `vim.pack`
- `task nvim:tools` Install Commitizen for the LazyGit shortcut

`task link` backs up an existing non-matching path next to the original before replacing it with a dotfiles symlink.
For example:

```sh
~/.config/example.backup.<timestamp>
```

## Shared AI Instructions

Personal AI instructions live in `.config/ai/AGENTS.md`. `task link` exposes the same file to both clients:

```text
~/.codex/AGENTS.md -> ~/.dotfiles/.config/ai/AGENTS.md
~/.claude/CLAUDE.md -> ~/.dotfiles/.config/ai/AGENTS.md
```

The instructions use the Obsidian CLI to search and update the local Vault. They include a compact map of the current Vault folders, an example of the Daily format, baseline YAML properties for new notes, and folder-specific filename conventions. Markdown notes use their filenames as titles and begin body sections at H2. Daily notes are chronological worklogs where each activity uses a time-stamped H2 heading. Concrete relationships use wikilinks, while tags are reserved for stable cross-note classification. Longer investigations live under `04_Thinking/`, durable knowledge is integrated into existing topic notes, and automatically maintained indexes use Obsidian Bases. Vault reads and writes are reported explicitly, and relevant verification is completed as part of the task.

Agent Skills live under `.config/ai/skills`. `task link` discovers every directory containing `SKILL.md` and links it to both clients automatically:

```text
~/.codex/skills/<skill-name> -> ~/.dotfiles/.config/ai/skills/<skill-name>
~/.claude/skills/<skill-name> -> ~/.dotfiles/.config/ai/skills/<skill-name>
```

Adding another Skill does not require changing `Taskfile.yml`. The personal workflow remains in `AGENTS.md`; Skills provide task-specific guidance only.

`obsidian-project-log` records meaningful repository work under `02_Projects/<project>/logs/YYYY-MM-DD.md`, which acts as the project-specific Daily note. Repository work is not duplicated in the global Daily. Project logs use wikilinks for concrete relationships and tags only for stable classification. The Skill derives a safe project name locally without writing remote URLs or organization names to the Vault, so the same workflow can be used for personal and business repositories.

`task check` validates required config paths, Taskfile readability, zsh syntax, mise config readability, and optional app checks when the tools are installed:
`stylua --check .config/nvim`, WezTerm key binding validation, and Ghostty config validation.

## Neovim

The editor uses Neovim 0.12+, built-in `vim.pack`, and Kanagawa Dragon. `task nvim:sync` updates plugins; Mason installs language tools when Neovim starts. `git-delta` supplies LazyGit's diff renderer. Keymaps and daily use are documented in `.config/nvim/README.md`.

## LazyGit

LazyGit uses a darker gray selected-line background so focused rows stay visible without washing out file diffs.
Neovim opens LazyGit with `;g`. Git diffs use `delta`; automatic fetch and mouse input are disabled.
The file panel's `C` command runs Commitizen. `task link` links `.config/git/.czrc` to `~/.czrc`; `task nvim:tools` installs its CLI.
On macOS, `task link` links this repo's `.config/lazygit` to:

```sh
~/Library/Application Support/lazygit
```

## Shell And Runtimes

Runtime versions are managed by mise and pinned by major or minor series in `.config/mise/config.toml`.
This avoids unexpected major upgrades while still allowing patch updates within the selected series.

`task link` manages both `~/.zprofile` and `~/.zshrc`; login shells load `.zshrc` once through zsh's normal startup sequence.
zsh initializes mise, direnv, and Vite Plus when `~/.vite-plus/env` exists.
Interactive local shells opened by Ghostty or WezTerm automatically attach to the `main` tmux session.
The tmux check runs before Powerlevel10k Instant Prompt so its temporary terminal redirection cannot affect the TTY guard.
Set `DOTFILES_SKIP_TMUX=1` before starting a shell to bypass auto-attach temporarily.
`obsidian-safe` starts Obsidian if needed and retries Obsidian CLI commands for up to eight seconds, which helps when the app's CLI connection is not ready immediately after launch.

```sh
obsidian-safe vaults
```

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

Ghostty's and WezTerm's native split shortcuts are disabled so pane ownership and shortcuts do not change between terminal states.

### Notes

- Reflect new changes here
- When unsure, re-check the Taskfile
