#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"
ZSHCONFIG="$CONFIG/zsh"
ZSHENV_TARGET="$ZSHCONFIG/.zshenv"
ZSHENV_LINK="$HOME/.zshenv"
ZSHRC_LINK="$HOME/.zshrc"
ZSHRC_SOURCE="$DOTFILES/.config/zshrc" # optional override target

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

# Ensure ~/.config exists
mkdir -p "$CONFIG"

# Symlink all config files inside ~/.config
info "Linking modular config files from .dotfiles/.config/"
find "$DOTFILES/.config" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    base="$(basename "$dir")"
    target="$CONFIG/$base"
    if [[ -e "$target" && ! -L "$target" ]]; then
        warn "Backing up existing $target to $target.bak"
        mv "$target" "$target.bak"
    fi
    ln -snf "$dir" "$target"
done

# Ensure .zshenv exists and is correct
info "Ensuring .zshenv exists and is correctly symlinked"
cat > "$ZSHENV_TARGET" <<'EOF'
# ~/.config/zsh/.zshenv — baseline shell environment
export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
EOF

# Symlink to ~/.zshenv so all shells pick it up
ln -sf "$ZSHENV_TARGET" "$ZSHENV_LINK"

# Ensure .zshrc is symlinked (optional logic)
if [[ -f "$ZSHCONFIG/.zshrc" ]]; then
    info "Linking ~/.zshrc to ~/.config/zsh/.zshrc"
    ln -sf "$ZSHCONFIG/.zshrc" "$ZSHRC_LINK"
elif [[ -f "$ZSHRC_SOURCE" ]]; then
    info "Linking ~/.zshrc from optional source: $ZSHRC_SOURCE"
    ln -sf "$ZSHRC_SOURCE" "$ZSHRC_LINK"
else
    warn "~/.zshrc not found in expected locations"
fi

info "Bootstrap complete. Restart your terminal."