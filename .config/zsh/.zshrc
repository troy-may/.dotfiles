# .zshrc modular file

# =====================
# Oh My Zsh Settings
# =====================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"  # Starship used as prompt engine

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
# export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
# eval "$(starship init zsh)"
# Added by Windsurf
export PATH="/Users/troymay/.codeium/windsurf/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/troymay/.lmstudio/bin"
# End of LM Studio CLI section

