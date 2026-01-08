#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"
ZSHCONFIG="$CONFIG/zsh"
FISHCONFIG="$CONFIG/fish"
ZSHENV_TARGET="$ZSHCONFIG/.zshenv"
ZSHENV_LINK="$HOME/.zshenv"
ZSHRC_LINK="$HOME/.zshrc"

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }

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
    info "✓ Linked $base"
done

# =====================================================
# Git Hooks Setup
# =====================================================
info "Installing git hooks for repository safety..."

HOOKS_DIR="$DOTFILES/hooks"
GIT_HOOKS_DIR="$DOTFILES/.git/hooks"

if [[ -d "$HOOKS_DIR" ]]; then
    for hook in "$HOOKS_DIR"/*; do
        if [[ -f "$hook" && -x "$hook" ]]; then
            hook_name="$(basename "$hook")"
            target="$GIT_HOOKS_DIR/$hook_name"
            cp "$hook" "$target"
            chmod +x "$target"
            info "✓ Installed $hook_name hook"
        fi
    done
else
    warn "Hooks directory not found at $HOOKS_DIR"
fi

# =====================================================
# Zsh Setup (Fallback Shell)
# =====================================================
info "Setting up Zsh (fallback shell)..."

# Ensure .zshenv exists and is correct
cat > "$ZSHENV_TARGET" <<'EOF'
# ~/.config/zsh/.zshenv — baseline shell environment
export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
EOF

# Symlink to ~/.zshenv so all shells pick it up
ln -sf "$ZSHENV_TARGET" "$ZSHENV_LINK"
info "✓ Created ~/.zshenv symlink"

# Ensure .zshrc is symlinked
if [[ -f "$ZSHCONFIG/.zshrc" ]]; then
    ln -sf "$ZSHCONFIG/.zshrc" "$ZSHRC_LINK"
    info "✓ Created ~/.zshrc symlink"
else
    warn "~/.config/zsh/.zshrc not found"
fi

# =====================================================
# Fish Setup (Primary Shell)
# =====================================================
info "Setting up Fish (primary shell)..."

# Fish respects XDG paths natively, no home directory symlinks needed
if [[ -d "$FISHCONFIG" ]]; then
    success "✓ Fish config already linked at $FISHCONFIG"
else
    warn "Fish config directory not found at $FISHCONFIG"
fi

# Check if fish is installed
if command -v fish >/dev/null 2>&1; then
    info "✓ Fish shell found at $(command -v fish)"

    # Check if fish is the default shell
    if [[ "$SHELL" == *"fish"* ]]; then
        success "✓ Fish is already your default shell"
    else
        warn "Fish is not your default shell"
        info "To set fish as default, run:"
        echo "    echo $(command -v fish) | sudo tee -a /etc/shells"
        echo "    chsh -s $(command -v fish)"
    fi
else
    warn "Fish shell not found. Install with: brew install fish"
fi

# =====================================================
# Summary
# =====================================================
echo ""
success "Bootstrap complete!"
echo ""
echo "Shell Setup:"
echo "  Primary:  fish  (interactive work)"
echo "  Fallback: zsh   (POSIX compatibility)"
echo ""
echo "Next Steps:"
echo "  1. Restart your terminal"
echo "  2. Verify fish config: fish -c 'which starship'"
echo "  3. Verify zsh config:  zsh -c 'echo \$ZDOTDIR'"
echo ""
info "Run './preflight.sh' to verify environment setup"