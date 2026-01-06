# =====================================================
# Fish Shell Configuration
# =====================================================
# Clean, minimal config for interactive shell work
# Fallback to zsh for POSIX scripts: #!/bin/zsh

if status is-interactive
    # =====================================================
    # Starship Prompt
    # =====================================================
    starship init fish | source

    # =====================================================
    # Carapace Completions
    # =====================================================
    # Modern completion engine with command descriptions
    set -gx CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    mkdir -p ~/.config/fish/completions
    carapace _carapace | source

    # =====================================================
    # Environment Variables
    # =====================================================
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx LANG en_US.UTF-8

    # XDG Base Directory Specification
    set -gx XDG_CONFIG_HOME $HOME/.config
    set -gx XDG_CACHE_HOME $HOME/.cache
    set -gx XDG_DATA_HOME $HOME/.local/share

    # =====================================================
    # Path Configuration
    # =====================================================
    # Add common development paths
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin

    # GNU coreutils and sed (prefer over macOS defaults)
    fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
    fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin

    # LM Studio
    fish_add_path $HOME/.lmstudio/bin

    # =====================================================
    # Python Environment (pyenv)
    # =====================================================
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    if command -v pyenv >/dev/null
        pyenv init - | source
    end

    # =====================================================
    # Node Version Manager (nvm)
    # =====================================================
    # For fish, use bass or the fisher nvm plugin for best results
    # Install: fisher install jorgebucaran/nvm.fish
    # Or use bass: fisher install edc/bass
    # For now, using basic nvm support

    # =====================================================
    # Basic Aliases
    # =====================================================
    # Navigation
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'

    # Listing (using built-in ls for now)
    alias ll 'ls -lah'
    alias la 'ls -a'

    # Git shortcuts
    alias gs 'git status'
    alias ga 'git add'
    alias gc 'git commit'
    alias gp 'git push'
    alias gl 'git pull'
    alias gd 'git diff'
    alias glog 'git log --oneline --graph --decorate'

    # Development
    alias vim nvim
    alias vi nvim

    # Utilities
    alias path 'echo $PATH | tr " " "\n"'

    # =====================================================
    # Fish-Specific Settings
    # =====================================================
    # Disable greeting
    set -g fish_greeting

    # Enable vi key bindings (optional, comment out if you prefer emacs/default)
    # fish_vi_key_bindings
end
