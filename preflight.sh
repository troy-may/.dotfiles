#!/usr/bin/env bash
set -euo pipefail

ZSHENV="$HOME/.zshenv"
ZSHENV_EXPECTED="$HOME/.config/zsh/.zshenv"
ZSHRC="$HOME/.zshrc"
ZSHRC_EXPECTED="$HOME/.config/zsh/.zshrc"
CRITICAL_PATHS=(/usr/bin /bin /usr/sbin /sbin /opt/homebrew/bin /usr/local/bin)
CRITICAL_CMDS=(grep uname sw_vers file)

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

# Check ZDOTDIR
info "Checking \$ZDOTDIR"
ZDOTDIR_VALUE=$(zsh -c 'echo $ZDOTDIR')
if [[ "$ZDOTDIR_VALUE" == "$HOME/.config/zsh" ]]; then
    info "ZDOTDIR is correctly set to $ZDOTDIR_VALUE"
else
    warn "ZDOTDIR is not correctly set (found: $ZDOTDIR_VALUE)"
fi

# Check .zshenv symlink
info "Checking ~/.zshenv symlink"
if [[ -L "$ZSHENV" && "$(readlink "$ZSHENV")" == "$ZSHENV_EXPECTED" ]]; then
    info "~/.zshenv correctly symlinked to $ZSHENV_EXPECTED"
else
    warn "~/.zshenv is missing or not linked to $ZSHENV_EXPECTED"
fi

# Check .zshrc symlink
info "Checking ~/.zshrc symlink"
if [[ -L "$ZSHRC" && "$(readlink "$ZSHRC")" == "$ZSHRC_EXPECTED" ]]; then
    info "~/.zshrc correctly symlinked to $ZSHRC_EXPECTED"
else
    warn "~/.zshrc is missing or not linked to $ZSHRC_EXPECTED"
fi

# Check critical $PATH entries
info "Checking critical directories in \$PATH"
for dir in "${CRITICAL_PATHS[@]}"; do
    if [[ ":$PATH:" == *":$dir:"* ]]; then
        info "✔ $dir is in \$PATH"
    else
        warn "✘ $dir is missing from \$PATH"
    fi
done

# Check if critical commands are resolvable
info "Checking command availability"
for cmd in "${CRITICAL_CMDS[@]}"; do
    if command -v "$cmd" >/dev/null; then
        info "✔ $cmd found at $(command -v $cmd)"
    else
        error "✘ $cmd not found in \$PATH"
    fi
done