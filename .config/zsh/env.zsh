# ~/.config/zsh/env.zsh — Environment Variables and PATH

# =====================
# Locale and Encoding
# =====================
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"

# =====================
# XDG Base Directory Specification
# =====================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# =====================
# Path Management
# =====================
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# =====================
# Python Environment (pyenv)
# =====================
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# =====================
# Node Version Manager (fnm)
# =====================
# Fast Node Manager - cross-shell compatible (replaces nvm)
# Automatically switches Node versions based on .node-version or .nvmrc files
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd)"
fi
