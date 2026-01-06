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
# Node Version Manager (nvm)
# =====================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
