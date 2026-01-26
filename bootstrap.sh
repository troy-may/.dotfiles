# bootstrap.sh
# version: 2026-01-26.3
# purpose: symlink XDG config + install git hooks + wire zsh entrypoints safely
# invariants:
#   - repo is source of truth (never overwrite config content)
#   - symlinks are explicit and intentional
#   - zsh loads from ZDOTDIR (~/.config/zsh)
#   - ~/.zshrc is a stub delegating to $ZDOTDIR/.zshrc

#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"

ZSHCONFIG="$CONFIG/zsh"
FISHCONFIG="$CONFIG/fish"

ZSHENV_TARGET="$ZSHCONFIG/.zshenv"
ZSHENV_LINK="$HOME/.zshenv"
ZSHRC_LINK="$HOME/.zshrc"

info()    { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error()   { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $*"; }

# Ensure ~/.config exists
mkdir -p "$CONFIG"

# =====================================================
# Link ~/.config modules from ~/.dotfiles/.config
# =====================================================
info "Linking modular config directories from .dotfiles/.config/"

if [[ ! -d "$DOTFILES/.config" ]]; then
  error "Missing $DOTFILES/.config — is this repo cloned to ~/.dotfiles?"
  exit 1
fi

find "$DOTFILES/.config" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
  base="$(basename "$dir")"
  target="$CONFIG/$base"

  if [[ -e "$target" && ! -L "$target" ]]; then
    warn "Backing up existing $target to $target.bak"
    mv "$target" "$target.bak"
  fi

  ln -snf "$dir" "$target"
  info "✓ Linked ~/.config/$base"
done

# =====================================================
# Git Hooks Setup
# =====================================================
info "Installing git hooks for repository safety..."

HOOKS_DIR="$DOTFILES/hooks"
GIT_HOOKS_DIR="$DOTFILES/.git/hooks"

if [[ -d "$HOOKS_DIR" && -d "$GIT_HOOKS_DIR" ]]; then
  for hook in "$HOOKS_DIR"/*; do
    if [[ -f "$hook" && -x "$hook" ]]; then
      hook_name="$(basename "$hook")"
      cp "$hook" "$GIT_HOOKS_DIR/$hook_name"
      chmod +x "$GIT_HOOKS_DIR/$hook_name"
      info "✓ Installed $hook_name hook"
    fi
  done
else
  warn "Hooks dir or git hooks dir missing: $HOOKS_DIR or $GIT_HOOKS_DIR"
fi

# =====================================================
# Zsh Setup (Fallback Shell)
# =====================================================
info "Setting up Zsh (fallback shell)..."

# 1) ~/.zshenv must exist and point into the repo-managed XDG config
if [[ -f "$ZSHENV_TARGET" ]]; then
  if [[ -e "$ZSHENV_LINK" && ! -L "$ZSHENV_LINK" ]]; then
    warn "Backing up existing $ZSHENV_LINK to $ZSHENV_LINK.bak"
    mv "$ZSHENV_LINK" "$ZSHENV_LINK.bak"
  fi
  ln -sf "$ZSHENV_TARGET" "$ZSHENV_LINK"
  info "✓ Linked ~/.zshenv -> $ZSHENV_TARGET"
else
  warn "Missing $ZSHENV_TARGET — zsh will not consistently use ZDOTDIR"
  warn "Ensure ~/.config/zsh/.zshenv exists in the repo (.dotfiles/.config/zsh/.zshenv)"
fi

# 2) ~/.zshrc should be a tiny stub for tools that insist on it
#    (zsh itself should load from $ZDOTDIR/.zshrc)
ZSHRC_STUB_CONTENT=$'# ~/.zshrc (stub)\n# Delegates to XDG zsh config in $ZDOTDIR.\n# Source of truth: ~/.config/zsh/.zshrc\n\nexport ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"\n[[ -f "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"\n'

if [[ -e "$ZSHRC_LINK" && ! -L "$ZSHRC_LINK" ]]; then
  # Only replace if it isn’t already the expected stub
  if ! grep -q 'Delegates to XDG zsh config' "$ZSHRC_LINK" 2>/dev/null; then
    warn "Backing up existing $ZSHRC_LINK to $ZSHRC_LINK.bak"
    mv "$ZSHRC_LINK" "$ZSHRC_LINK.bak"
    printf "%s" "$ZSHRC_STUB_CONTENT" > "$ZSHRC_LINK"
    info "✓ Wrote ~/.zshrc stub"
  else
    info "✓ ~/.zshrc stub already present"
  fi
elif [[ -L "$ZSHRC_LINK" ]]; then
  # If it's a symlink, prefer replacing it with a real stub file (more robust)
  warn "~/.zshrc is a symlink; replacing with a stub file"
  rm -f "$ZSHRC_LINK"
  printf "%s" "$ZSHRC_STUB_CONTENT" > "$ZSHRC_LINK"
  info "✓ Wrote ~/.zshrc stub"
else
  printf "%s" "$ZSHRC_STUB_CONTENT" > "$ZSHRC_LINK"
  info "✓ Wrote ~/.zshrc stub"
fi

# =====================================================
# Fish Setup (Primary Shell)
# =====================================================
info "Setting up Fish (primary shell)..."

if [[ -d "$FISHCONFIG" ]]; then
  success "✓ Fish config present at $FISHCONFIG"
else
  warn "Fish config directory not found at $FISHCONFIG"
fi

if command -v fish >/dev/null 2>&1; then
  info "✓ Fish shell found at $(command -v fish)"

  if [[ "${SHELL:-}" == *"fish"* ]]; then
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
echo "  3. Verify zsh config:  zsh -ic 'echo \$ZDOTDIR'"
echo ""
info "Run './preflight.sh' to verify environment setup"