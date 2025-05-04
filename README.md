# .dotfiles

📁 Personal dotfiles setup for macOS (and adaptable to Linux). Clean, modular, and XDG-compliant.

## Structure

```
.dotfiles/
├── bootstrap.sh               # Bootstrap script to link configs and set up system
├── README.md                  # This file – explains setup and structure
└── .config/                   # XDG-compliant configuration directory
    ├── zsh/                   # Modular Zsh setup
    │   ├── aliases.zsh
    │   ├── env.zsh
    │   ├── plugins.zsh
    │   └── functions.zsh
    ├── starship/              # Starship prompt config
    │   └── starship.toml
    └── wezterm/               # (Optional) WezTerm terminal config
        └── wezterm.lua
```

## Setup

1. Clone the repo:

```bash
git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
```

2. Run the bootstrap script:

```bash
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
# or
bash bootstrap.sh
```

3. Restart your terminal.

## Philosophy

- ✅ Modular and commented config files
- ✅ Symlinks via `~/.dotfiles`
- ✅ Follows XDG base directory spec
- ✅ Uses `~/.config` for all CLI tools

## Tools in Use

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship Prompt](https://starship.rs)
- [Homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)

## License

MIT — use and adapt freely.


## Optional: Install Recommended CLI Tools (macOS with Homebrew)

Once the dotfiles are linked, you can install your favorite CLI tools with:

```bash
brew install starship zoxide eza bat fzf ripgrep fd tmux
```

### Tool Descriptions

- `starship` – A fast, customizable prompt
- `zoxide` – A smarter `cd` command with learning
- `eza` – A modern replacement for `ls`
- `bat` – A better `cat` with syntax highlighting
- `fzf` – Fuzzy finder for searching files/history
- `ripgrep` – Fast recursive grep
- `fd` – User-friendly `find`
- `tmux` – Terminal multiplexer for sessions/splits



## Syncing Dotfiles Across Machines

To use this dotfiles setup on another machine (e.g., your laptop):

1. Ensure your SSH key is added to GitHub.
2. Clone your dotfiles:

```bash
git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

3. Restart your terminal.

To keep in sync:
```bash
cd ~/.dotfiles
git pull origin main
./bootstrap.sh  # Re-run if config structure has changed
```

## Optional: Share Zsh History or Scripts

Use `rsync` or a tool like `Syncthing` to copy private items like history or personal scripts:

```bash
rsync -avz ~/.zsh_history your-laptop.local:~/
rsync -avz ~/.local/bin/ your-laptop.local:~/.local/bin/
```

## Optional: GitHub Actions CI Badge

Once you add a `.github/workflows/ci.yml` for testing or linting, include this badge:

```md
![CI](https://github.com/troy-may/.dotfiles/actions/workflows/ci.yml/badge.svg)
```

