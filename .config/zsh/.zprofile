# ~/.config/zsh/.zprofile
# version: 2026-01-26.2
# purpose: login-shell environment + PATH extensions for zsh (ZDOTDIR-based)

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# PATH extensions (baseline PATH lives in .zshenv)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.lmstudio/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
