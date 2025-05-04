# ~/.config/zsh/functions.zsh — Custom Shell Functions

# =====================
# Backup Dotfiles
# =====================
backup_dotfiles() {
  rsync -av --exclude=".git" ~/dotfiles/ ~/dotfiles_backup/
}
