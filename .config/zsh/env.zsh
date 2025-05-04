# ~/.config/zsh/env.zsh — Environment Variables and PATH Setup

# =====================
# Locale and Encoding
# =====================
export LANG="en_US.UTF-8"

# =====================
# XDG Base Directory Specification
# =====================
# These vars standardize where apps store config, cache, and data
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# =====================
# Path Management
# =====================
# Prepend custom locations to PATH
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/Users/troymay/.lmstudio/bin"

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

# =====================
# FZF Configuration (optional)
# =====================
# Uncomment and adjust if you want to control FZF behavior from here
# export FZF_DEFAULT_OPTS="--height 40% --reverse --preview 'bat --style=numbers --color=always {}'"

# =====================
# Starship Prompt Config Location
# =====================
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
