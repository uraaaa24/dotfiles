# Repository Guidelines

## Project Structure & Module Organization
This repo is a dotfiles collection. Most configuration lives at the root or in `.config`.

- Root: `Brewfile`, `Taskfile.yml`, `README.md`, `.editorconfig`, `.gitconfig`, `.zshrc`, `.czrc`.
- Neovim: `.config/nvim/` with `init.lua`, `lua/` modules, `lazy-lock.json`, and `stylua.toml`.
- Other configs: `.config/git/`, `.config/mise/`, `.config/wezterm/`.

## Build, Test, and Development Commands
Use `task` for setup and maintenance.

- `task setup`: full setup (link + Homebrew + mise).
- `task link`: symlink dotfiles into `$HOME`.
- `task brew:bootstrap`: install Homebrew if missing.
- `task brew:bundle`: install packages from `Brewfile`.
- `task brew:update`: update Homebrew packages.
- `task brew:doctor`: run Homebrew diagnostics.
- `task mise:install`: install runtimes via mise.
- `task nvim:sync`: sync Neovim plugins.

## Coding Style & Naming Conventions
- `.editorconfig` enforces 2-space indentation, LF line endings, and trimmed trailing whitespace (except Markdown).
- Lua formatting uses `stylua` with 2-space indentation and 120 column width (see `.config/nvim/stylua.toml`).
- Keep paths and filenames lowercase and consistent with existing structure (e.g., `.config/nvim/lua/...`).

## Testing Guidelines
There are no automated tests in this repo. Validate changes by running the relevant task and opening the app:

- Neovim: `task nvim:sync` then open `nvim`.
- WezTerm or shell changes: restart the app/shell to confirm behavior.

## Commit & Pull Request Guidelines
Git history follows Conventional Commits (e.g., `feat: ...`). Use `feat:`, `fix:`, or `chore:` prefixes when possible.

For PRs, keep changes focused and include:
- A short summary of what changed and why.
- Any commands run (e.g., `task link`, `task nvim:sync`).
- Screenshots only when UI changes are visible (e.g., WezTerm appearance).

## Configuration & Safety Notes
`task link` overwrites symlinks in `$HOME`. Review changes before running, or set `DOTFILES` to point at an alternate location.
