# =====================================================
# Fish Shell Configuration
# =====================================================
# version: 2026-01-26.1
# purpose: interactive spine (fish + starship + carapace + zoxide) with clean PATH
# invariants:
#   - no universal vars set here (no `set -U*`)
#   - PATH is defined here (no installer footers appending PATH later)
#   - zsh is fallback for POSIX-isms / legacy scripts

if status is-interactive
    # =====================================================
    # Path Configuration (MUST BE FIRST)
    # =====================================================
    # Homebrew first (so brew tools win)
    fish_add_path -g /opt/homebrew/bin
    fish_add_path -g /opt/homebrew/sbin

    # Prefer GNU coreutils and sed over macOS defaults (only if you truly want this globally)
    fish_add_path -g /opt/homebrew/opt/coreutils/libexec/gnubin
    fish_add_path -g /opt/homebrew/opt/gnu-sed/libexec/gnubin

    # User bins
    fish_add_path -g $HOME/bin
    fish_add_path -g $HOME/.local/bin

    # LM Studio
    fish_add_path -g $HOME/.lmstudio/bin

    # pyenv (PATH entry only; init happens later)
    if test -d $HOME/.pyenv
        set -gx PYENV_ROOT $HOME/.pyenv
        fish_add_path -g $PYENV_ROOT/bin
    end

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
    # zoxide (smart cd)
    # =====================================================
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end

    # =====================================================
    # Carapace Completions
    # =====================================================
    # Keep this session-scoped (not universal) so config remains the source of truth.
    set -gx CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    if command -v carapace >/dev/null
        carapace _carapace fish | source
    end
    
    # =====================================================
    # Python Environment (pyenv)
    # =====================================================
    if test -d $HOME/.pyenv
        pyenv init - | source
    end

    # =====================================================
    # Node Version Manager (fnm)
    # =====================================================
    if command -v fnm >/dev/null
        fnm env --use-on-cd | source
    end

    # =====================================================
    # fzf - Fuzzy Finder
    # =====================================================
    if command -v fzf >/dev/null
        # Use fd for better file finding (respects .gitignore)
        if command -v fd >/dev/null
            set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
            set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        end

        # Better fzf defaults
        set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --info=inline'

        # Ctrl-T preview with bat (if available)
        if command -v bat >/dev/null
            set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:100 {}' --preview-window=right:60%:wrap"
        end

        # Initialize fzf key bindings and completions
        fzf --fish | source
    end

    # =====================================================
    # bat - Better cat
    # =====================================================
    if command -v bat >/dev/null
        alias cat 'bat --style=auto'
        alias catt '/bin/cat'  # Keep original cat available
        alias batp 'bat --style=plain'
    end

    # =====================================================
    # Basic Aliases
    # =====================================================
    # Navigation
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'

    # Listing
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
    # Note: 'path' is a Fish builtin - don't override it!
    alias showpath 'string join \n $PATH'

    # =====================================================
    # Fish-Specific Settings
    # =====================================================
    # Disable greeting
    set -g fish_greeting

    # Enable vi key bindings (optional, comment out if you prefer emacs/default)
    # fish_vi_key_bindings
end