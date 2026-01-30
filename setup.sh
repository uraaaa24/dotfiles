#!/usr/bin/env bash

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

echo "🔗 Linking dotfiles..."

# ---- Link dotfiles ----
link_one() {
  local target=$1
  local link_path=$2

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$link_path")"

  ln -snf "$target" "$link_path"
  echo "  ✔ $link_path → $target"
}

link_all() {
  local mapping
  local target
  local link_path

  for mapping in "$@"; do
    IFS='|' read -r target link_path <<<"$mapping"
    link_one "$target" "$link_path"
  done
}

link_all \
  "$DOTFILES/.zshrc|$HOME/.zshrc" \
  "$DOTFILES/.config/nvim|$HOME/.config/nvim" \
  "$DOTFILES/.config/mise|$HOME/.config/mise" \
  "$DOTFILES/.config/wezterm|$HOME/.config/wezterm"

# ---- Homebrew ----
echo "🍺 Checking Homebrew..."

if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew not found. Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "🍺 Homebrew is already installed."
fi

if command -v brew &>/dev/null; then
  brew_prefix="$(brew --prefix)"
  if [[ -d "$brew_prefix/share" ]]; then
    echo "🔐 Ensuring Homebrew share directory is not group/other writable..."
    chmod go-w "$brew_prefix/share" 2>/dev/null || true
    echo "  ✔ Checked $brew_prefix/share"
  fi
fi

echo "🔧 Installing Homebrew packages via Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

# ---- mise ----
echo "🚀 Installing runtimes via mise..."
if command -v mise &>/dev/null; then
  mise install
else
  echo "⚠️ mise not installed."
fi

echo "🎉 Setup completed!"
