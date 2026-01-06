# =====================================================
# Zsh Configuration - Clean Fallback Shell
# =====================================================
# Primary shell: fish (for interactive work)
# Fallback shell: zsh (for POSIX compatibility, scripts, SSH)
# =====================================================

# =====================
# Load Modular Config Files
# =====================
for config_file ($HOME/.config/zsh/*.zsh); do
  source $config_file
done

# =====================
# Starship Prompt (Unified)
# =====================
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# =====================
# Zsh Options
# =====================
# History
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive

# =====================
# Additional Tool Paths
# =====================
# LM Studio
export PATH="$PATH:/Users/troymay/.lmstudio/bin"

