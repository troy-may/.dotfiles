#!/usr/bin/env bash
# preflight.sh
# version: 2026-01-26.3
# purpose: verify zsh ZDOTDIR wiring + entrypoint stubs + essential PATH/tools
# invariants:
#   - ZDOTDIR must be set inside zsh via ~/.zshenv
#   - ~/.zshrc must delegate to $ZDOTDIR/.zshrc
#   - ZDOTDIR must be ~/.config/zsh
#   - ~/.zshenv must be a symlink to $ZDOTDIR/.zshenv (link text check; do NOT realpath through repo symlinks)
#   - ~/.zshrc may be either:
#       (a) a stub file that sources $ZDOTDIR/.zshrc (preferred)
#       (b) a symlink to $ZDOTDIR/.zshrc (legacy acceptable)
#   - PATH must contain core system dirs + Homebrew dirs

set -euo pipefail

info()  { echo "[INFO] $*"; }
warn()  { echo "[WARN] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

ZDOTDIR_EXPECT="$HOME/.config/zsh"
ZSHENV_LINK="$HOME/.zshenv"
ZSHRC_PATH="$HOME/.zshrc"
ZSHENV_TARGET="$ZDOTDIR_EXPECT/.zshenv"
ZSHRC_TARGET="$ZDOTDIR_EXPECT/.zshrc"

# ------------------------------------------------------------
# ZDOTDIR must be correct inside zsh (not necessarily in this shell)
# ------------------------------------------------------------
info "Checking ZDOTDIR inside zsh"
zsh_zdotdir="$(zsh -ic 'printf "%s" "${ZDOTDIR:-}"' 2>/dev/null || true)"
if [[ -z "$zsh_zdotdir" ]]; then
  error "ZDOTDIR is not set inside zsh. Check ~/.zshenv wiring."
fi
if [[ "$zsh_zdotdir" != "$ZDOTDIR_EXPECT" ]]; then
  error "ZDOTDIR inside zsh is '$zsh_zdotdir' (expected '$ZDOTDIR_EXPECT')"
fi
info "✓ ZDOTDIR inside zsh is correctly set to $zsh_zdotdir"

# ------------------------------------------------------------
# ~/.zshenv must be a symlink to $ZDOTDIR/.zshenv
# IMPORTANT: validate link text (readlink), not realpath (because ~/.config is a symlink into the repo)
# ------------------------------------------------------------
info "Checking ~/.zshenv symlink"
if [[ ! -L "$ZSHENV_LINK" ]]; then
  error "~/.zshenv is not a symlink (expected -> $ZSHENV_TARGET)"
fi

zshenv_link_text="$(readlink "$ZSHENV_LINK" || true)"
if [[ -z "$zshenv_link_text" ]]; then
  error "Could not read ~/.zshenv symlink target"
fi

if [[ "$zshenv_link_text" != "$ZSHENV_TARGET" ]]; then
  error "~/.zshenv link target is '$zshenv_link_text' (expected '$ZSHENV_TARGET')"
fi
info "✓ ~/.zshenv links to $ZSHENV_TARGET"

# ------------------------------------------------------------
# ~/.zshrc wiring: preferred stub file; legacy symlink acceptable
# ------------------------------------------------------------
info "Checking ~/.zshrc wiring"
if [[ -L "$ZSHRC_PATH" ]]; then
  zshrc_link_text="$(readlink "$ZSHRC_PATH" || true)"
  if [[ -z "$zshrc_link_text" ]]; then
    error "Could not read ~/.zshrc symlink target"
  fi
  if [[ "$zshrc_link_text" == "$ZSHRC_TARGET" ]]; then
    info "✓ ~/.zshrc is symlinked to $ZSHRC_TARGET (legacy acceptable)"
  else
    error "~/.zshrc is a symlink but link target is '$zshrc_link_text' (expected '$ZSHRC_TARGET')"
  fi
elif [[ -f "$ZSHRC_PATH" ]]; then
  # Stub must reference $ZDOTDIR/.zshrc
  if grep -qE '(\$ZDOTDIR/\.zshrc|"\$ZDOTDIR/\.zshrc"|'\''\$ZDOTDIR/\.zshrc'\'')' "$ZSHRC_PATH"; then
    info "✓ ~/.zshrc stub delegates to \$ZDOTDIR/.zshrc"
  else
    error "~/.zshrc exists but does not appear to delegate to \$ZDOTDIR/.zshrc"
  fi
else
  error "~/.zshrc is missing"
fi

# Ensure the target config exists (repo-managed interactive zsh config)
if [[ ! -f "$ZSHRC_TARGET" ]]; then
  error "Missing $ZSHRC_TARGET (expected repo-managed interactive zsh config)"
fi

# Ensure the zshenv target exists (repo-managed baseline)
if [[ ! -f "$ZSHENV_TARGET" ]]; then
  error "Missing $ZSHENV_TARGET (expected repo-managed baseline zshenv)"
fi

# ------------------------------------------------------------
# PATH sanity (current shell)
# ------------------------------------------------------------
info "Checking critical directories in \$PATH"
must_have=(
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
)

for d in "${must_have[@]}"; do
  if [[ ":$PATH:" == *":$d:"* ]]; then
    info "✔ $d is in \$PATH"
  else
    warn "✘ $d is NOT in \$PATH"
  fi
done

# ------------------------------------------------------------
# Basic command availability (current shell)
# ------------------------------------------------------------
info "Checking command availability"
need_cmds=(grep uname sw_vers file)
for c in "${need_cmds[@]}"; do
  if command -v "$c" >/dev/null 2>&1; then
    info "✔ $c found at $(command -v "$c")"
  else
    warn "✘ $c not found"
  fi
done

info "✓ Preflight complete"