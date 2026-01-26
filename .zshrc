# ~/.zshrc (stub)
# version: 2026-01-26.3
# purpose: delegate to XDG zsh config (source of truth: ~/.config/zsh/.zshrc)
# Keep this stub minimal and robust: set ZDOTDIR fallback to ~/.config/zsh and source $ZDOTDIR/.zshrc. No other logic.

export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
[[ -f "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"
