# ~/.config/zsh/functions.zsh
# version: 2026-01-26.1
# purpose: a few durable utility functions for zsh fallback

backup_dotfiles() {
  rsync -av --exclude=".git" "$HOME/dotfiles/" "$HOME/dotfiles_backup/"
}

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

extract() {
  local file="$1"
  [[ -f "$file" ]] || { echo "'$file' is not a valid file"; return 1; }

  case "$file" in
    *.tar.bz2)  tar xjf -- "$file" ;;
    *.tar.gz)   tar xzf -- "$file" ;;
    *.tar)      tar xf  -- "$file" ;;
    *.tbz2)     tar xjf -- "$file" ;;
    *.tgz)      tar xzf -- "$file" ;;
    *.bz2)      command -v bunzip2 >/dev/null && bunzip2 -- "$file" || echo "bunzip2 not found" ;;
    *.gz)       gunzip -- "$file" ;;
    *.zip)      unzip -- "$file" ;;
    *.Z)        uncompress -- "$file" ;;
    *.7z)       command -v 7z >/dev/null && 7z x -- "$file" || echo "7z not found" ;;
    *.rar)      command -v unrar >/dev/null && unrar e -- "$file" || echo "unrar not found" ;;
    *)          echo "'$file' cannot be extracted" ; return 2 ;;
  esac
}