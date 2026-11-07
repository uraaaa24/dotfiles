# ============================================================
#  tmux
# ============================================================
# Run before Powerlevel10k Instant Prompt can temporarily redirect stdin/stdout.
# Set DOTFILES_SKIP_TMUX=1 before starting the shell to bypass auto-attach.
if [[ -o interactive ]] &&
  [[ -z ${TMUX:-} ]] &&
  [[ -z ${SSH_CONNECTION:-} && -z ${SSH_TTY:-} ]] &&
  [[ ${DOTFILES_SKIP_TMUX:-0} != 1 ]] &&
  [[ -t 0 && -t 1 ]] &&
  [[ ${TERM_PROGRAM:-} == ghostty || -n ${WEZTERM_PANE:-} ]] &&
  command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s main
fi

# ============================================================
#  Powerlevel10k Instant Prompt
# ============================================================
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
#  Basic Settings & Paths
# ============================================================

# PATH settings
path=(
  /opt/homebrew/bin
  /opt/homebrew/opt/postgresql@15/bin
  $path
)
export PATH

# ============================================================
#  History
# ============================================================
HISTFILE=~/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# ============================================================
#  Aliases
# ============================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias lla='ls -al'
alias vim='nvim'

# ============================================================
#  SDKMAN
# ============================================================
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# ============================================================
#  Powerlevel10k Theme
# ============================================================
if [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi

# ============================================================
#  zsh-completions
# ============================================================
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
fi

autoload -Uz compinit
compinit

# ============================================================
#  mise
# ============================================================
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ============================================================
#  direnv
# ============================================================
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# ============================================================
#  Terraform completion
# ============================================================
autoload -U +X bashcompinit && bashcompinit
if command -v terraform >/dev/null 2>&1; then
  complete -o nospace -C terraform terraform
fi

# ============================================================
#  zsh plugins
# ============================================================
if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ============================================================
#  Vite Plus
# ============================================================
if [[ -r "$HOME/.vite-plus/env" ]]; then
  . "$HOME/.vite-plus/env"
fi
