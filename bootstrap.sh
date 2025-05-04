#!/bin/bash
# bootstrap.sh — Setup script for dotfiles on a fresh system

set -e

echo "🔧 Setting up symbolic links for dotfiles..."

# Symlink .zshrc
ln -sf ~/.dotfiles/.zshrc ~/.zshrc

# Symlink Zsh config directory
mkdir -p ~/.config
ln -sf ~/.dotfiles/.config/zsh ~/.config/zsh

# Symlink Starship config
ln -sf ~/.dotfiles/.config/starship ~/.config/starship

# Symlink WezTerm config (if used)
[ -d ~/.dotfiles/.config/wezterm ] && ln -sf ~/.dotfiles/.config/wezterm ~/.config/wezterm

# Set up Git global config (optional)
[ -f ~/.dotfiles/.gitconfig ] && ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig

echo "✅ Dotfiles linked."
echo "📦 Installing Homebrew (macOS only)..."

# Install Homebrew if not present (macOS only)
if [[ "$OSTYPE" == "darwin"* ]] && ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "✅ Bootstrap complete. Please restart your terminal."
