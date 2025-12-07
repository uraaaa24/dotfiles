#!/usr/bin/env bash

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

echo "🔗 Linking dotfiles..."

# ---- Link dotfiles ----
link() {
  local target=$1
  local link_path=$2

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$link_path")"

  ln -snf "$target" "$link_path"
  echo "  ✔ $link_path → $target"
}

link "$DOTFILES/.zshrc" "$HOME/.zshrc"

link "$DOTFILES/config/nvim" "$HOME/.config/nvim"
link "$DOTFILES/config/mise" "$HOME/.config/mise"

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

brew_prefix="$(brew --prefix)"
if [[ -d "$brew_prefix/share" ]]; then
  echo "🔐 Fixing Homebrew share directory permissions..."
  sudo chmod go-w "$brew_prefix/share" 2>/dev/null || true
  echo "  ✔ Secured $brew_prefix/share"
fi

echo "🔧 Installing Homebrew packages via Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

# ---- mise ----
echo "🚀 Installing runtimes via mise..."
if command -v mise &>/dev/null; then
  mise install
else
  echo "⚠️ mise not installed via Brewfile?"
fi

echo "🎉 Setup completed!"
