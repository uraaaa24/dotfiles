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
  /opt/homebrew/opt/mysql@5.7/bin
  /usr/local/opt/php@7.4/bin
  /usr/local/opt/php@7.4/sbin
  /opt/homebrew/opt/postgresql@15/bin
  /opt/homebrew/bin
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
if [[ -s "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
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
#  Terraform completion
# ============================================================
autoload -U +X bashcompinit && bashcompinit
if [[ -x /opt/homebrew/bin/terraform ]]; then
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
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
