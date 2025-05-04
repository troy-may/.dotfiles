# ~/.config/zsh/env.zsh — Environment Variables and PATH

# =====================
# Locale and Editor
# =====================
export LANG="en_US.UTF-8"

# =====================
# Core Paths
# =====================
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$PATH:/Users/troymay/.lmstudio/bin"

# =====================
# Python (pyenv)
# =====================
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# =====================
# Node Version Manager (nvm)
# =====================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
