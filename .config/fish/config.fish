# =====================================================
# Fish Shell Configuration
# =====================================================
# Clean, minimal config for interactive shell work
# Fallback to zsh for POSIX scripts: #!/bin/zsh

if status is-interactive
    # =====================================================
    # Path Configuration (MUST BE FIRST)
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
    # Starship Prompt
    # =====================================================
    set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    starship init fish | source

    # =====================================================
    # Carapace Completions
    # =====================================================
    # Modern completion engine with command descriptions
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    carapace _carapace | source

    # =====================================================
    # Python Environment (pyenv)
    # =====================================================
    # Cross-shell compatible Python version manager
    if test -d $HOME/.pyenv
        set -gx PYENV_ROOT $HOME/.pyenv
        fish_add_path $PYENV_ROOT/bin
        status --is-interactive; and pyenv init - | source
    end

    # =====================================================
    # Node Version Manager (fnm)
    # =====================================================
    # Fast Node Manager - cross-shell compatible (replaces nvm)
    # Automatically switches Node versions based on .node-version or .nvmrc files
    if command -v fnm >/dev/null
        fnm env --use-on-cd | source
    end

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
