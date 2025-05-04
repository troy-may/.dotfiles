# ~/.zshrc — Clean Modular Setup with Oh My Zsh

# =====================
# Oh My Zsh Settings
# =====================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Starship used as prompt engine

# =====================
# Load Core Plugins (Empty Here)
# =====================
plugins=()  # Defined in ~/.config/zsh/plugins.zsh
source $ZSH/oh-my-zsh.sh

# =====================
# Load Modular Config Files
# =====================
for config_file ($HOME/.config/zsh/*.zsh); do
  source $config_file
done

# =====================
# Prompt Engine
# =====================
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
