function backup_dotfiles --description "Backup dotfiles directory"
    rsync -av --exclude=".git" ~/dotfiles/ ~/dotfiles_backup/
end
