# ~/.config/zsh/.zshrc
# version: 2026-01-26.6
# purpose: clean interactive zsh fallback (Starship + Carapace + zoxide)
# invariants: no PATH edits here (except pruning a dead system-injected entry)

# ---------------------
# History / behavior
# ---------------------
HISTFILE="$HOME/.config/zsh/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt NO_BEEP

# ---------------------
# Completion (native + Carapace)
# ---------------------
# Add Homebrew completions, without duplicating the entry
fpath=(/opt/homebrew/share/zsh/site-functions ${fpath:#/opt/homebrew/share/zsh/site-functions})

autoload -Uz compinit

# Keep compdump inside ZDOTDIR (avoid clutter elsewhere)
ZSH_COMPDUMP="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
compinit -u -d "$ZSH_COMPDUMP"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
setopt AUTO_MENU
setopt MENU_COMPLETE
bindkey '^I' menu-complete
zstyle ':completion:*' list-prompt ''

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
command -v carapace >/dev/null && source <(carapace _carapace)

# ---------------------
# Prompt (Starship)
# ---------------------
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
command -v starship >/dev/null && eval "$(starship init zsh)"

# ---------------------
# zoxide (smart cd)
# ---------------------
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# ---------------------
# Interactive tool inits
# ---------------------
if command -v pyenv >/dev/null; then
  eval "$(pyenv init -)"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

# ---------------------
# Optional modular extras (explicit, predictable)
# ---------------------
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
[[ -f "$HOME/.config/zsh/functions.zsh" ]] && source "$HOME/.config/zsh/functions.zsh"
# [[ -f "$HOME/.config/zsh/plugins.zsh" ]] && source "$HOME/.config/zsh/plugins.zsh"  # opt-in

# ---------------------
# Final PATH prune (wins last)
# ---------------------
path=(${path:#$HOME/.config/carapace/bin})
export PATH="${(j/:/)path}"