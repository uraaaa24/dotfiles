# dotfiles

Personal notes and quick re-setup steps.

## Purpose

- Keep setup fast and repeatable
- Prefer small, clear defaults over heavy customization
- Make maintenance easy with `task`

## Overview

- `.config/nvim` Neovim config
- `.config/git` Git defaults and global ignore
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

### Notes

- Reflect new changes here
- When unsure, re-check the Taskfile
