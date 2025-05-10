
# .dotfiles
2.0
📁 Personal dotfiles setup for macOS (and adaptable to Linux). Clean, modular, and XDG-compliant.

## Overview

This setup uses:

- `~/.dotfiles` for version-controlled configs
- `~/.config/` for XDG-compliant modular layouts
- `Oh My Zsh` as the plugin loader
- `Starship` for prompt rendering
- `.zshenv` to establish a safe, portable environment on all shells (interactive, login, and script)

## Structure

```
.dotfiles/
├── bootstrap.sh               # Bootstrap: install symlinks and .zshenv
├── preflight.sh               # Audit environment (ZDOTDIR, PATH, symlinks)
├── README.md                  # This file – explains setup and structure
└── .config/                   # XDG-compliant configuration directory
    ├── zsh/                   # Modular Zsh setup
    │   ├── .zshenv            # Path and ZDOTDIR setup (dotfile required)
    │   ├── .zshrc             # Main config, sourced via symlink from ~/
    │   ├── aliases.zsh        # User-defined aliases
    │   ├── env.zsh            # Environment variables
    │   ├── plugins.zsh        # Plugin declarations (OMZ plugins=() list)
    │   └── functions.zsh      # Custom shell functions
    ├── starship/              # Starship prompt config
    │   └── starship.toml
    └── wezterm/               # (Optional) WezTerm terminal config
        └── wezterm.lua
```

## Zsh Environment Setup

This dotfiles repo uses `~/.config/zsh/.zshenv` to configure:

- `ZDOTDIR` → redirects zsh to load config from `~/.config/zsh`
- `$PATH` → ensures core macOS binary locations are always available (`grep`, `uname`, etc.)

### Example: `.zshenv` contents

```zsh
# ~/.config/zsh/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
```

> ✅ You **must** symlink this to `~/.zshenv` for reliable shell behavior:
```bash
ln -sf ~/.config/zsh/.zshenv ~/.zshenv
```

## Setup

### 1. Clone the repo

```bash
git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
```

### 2. Run the bootstrap script

```bash
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

This will:

- Create symlinks from `~/.config/` to `.dotfiles/.config`
- Install `.zshenv` with stable path and ZDOTDIR logic
- Symlink `~/.zshenv` → `~/.config/zsh/.zshenv`
- Symlink `~/.zshrc` → `~/.config/zsh/.zshrc` if present

### 3. Restart your terminal

---

## Optional: Run Preflight Audit

Before or after running bootstrap, you can run a dry-check of your system:

```bash
cd ~/.dotfiles
chmod +x preflight.sh
./preflight.sh
```

It will verify:

- `ZDOTDIR` is set
- `.zshenv` and `.zshrc` symlinks are valid
- Core macOS binary paths are present in `$PATH`
- Shell essentials (`grep`, `uname`, `sw_vers`, `file`) are usable

---
## Tools in Use

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship Prompt](https://starship.rs)
- [Homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)

## Optional: Install Recommended CLI Tools (macOS with Homebrew)

Once the dotfiles are linked, you can install your favorite CLI tools:

## Recommended CLI Tools

```bash
brew install starship zoxide eza bat fzf ripgrep fd tmux
```

### Tool Descriptions

| Tool      | Purpose                              |
|-----------|--------------------------------------|
| starship  | Fast, cross-shell prompt             |
| zoxide    | Smart directory jumper (`cd` on steroids) |
| eza       | Modern replacement for `ls`          |
| bat       | Syntax-highlighted `cat`             |
| fzf       | Fuzzy finder                         |
| ripgrep   | Fast recursive grep                  |
| fd        | Simpler `find`                       |
| tmux      | Terminal multiplexer                 |

---

## Keeping in Sync Across Machines
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
To update and reapply links:

To keep in sync:
```bash
cd ~/.dotfiles
git pull origin main
./bootstrap.sh  # Re-run if config structure has changed
```
---

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


## Line Endings and File Consistency

This repo uses a `.gitattributes` file to normalize line endings:

- All text files use **LF (Unix-style)** endings
- Prevents issues when editing across macOS, Linux, or Windows
- Binary files like images and PDFs are excluded

This ensures consistent diffs and execution, especially for scripts.



## 🧱 System Task Map (STM)
This STM summarizes how to use and maintain your dotfiles across systems.

### 🧱 Foundation
- **Repo Location:** `~/.dotfiles`
- **Managed Items:** `.zshrc`, `~/.config/zsh/`, `~/.config/starship/`, etc.
- **Purpose:** Maintain a clean, modular, version-controlled CLI environment


| Area               | Task                                            |
|--------------------|-------------------------------------------------|
| Dotfiles repo      | `~/.dotfiles`                                   |
| Config directory   | `~/.config/zsh`, `~/.config/starship`, etc.     |
| ZDOTDIR target     | `~/.config/zsh`                                 |
| Path setup         | `.zshenv`(linked to home and used by all shells)|
| Shell prompt       | Starship + `.config/starship/starship.toml`     |
| Plugin manager     | Oh My Zsh                                       |
| Optional tools     | via `brew install`                              |
| Shell audit        | `preflight.sh`                                  |

---
### 🛠 Initial Setup

```bash
git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

- ✅ Symlinks dotfiles into place
- ✅ Loads modular `.zshrc` structure
- ✅ Uses Oh My Zsh + Starship + XDG paths

### 🔁 Ongoing Sync (Other Machines)

```bash
cd ~/.dotfiles
git pull
./bootstrap.sh
```

- 🔄 Updates configs from GitHub
- 🔗 Reapplies symlinks if structure changed

### 📦 Optional CLI Tools

Install with:

```bash
brew install starship zoxide eza bat fzf ripgrep fd tmux
```

### 📁 Key Repo Files

- `bootstrap.sh` – Setup script
- `README.md` – Usage and layout
- `.gitignore` – Clean, commented excludes
- `.gitattributes` – Enforce LF line endings

## Philosophy

- ✅ Modular and commented config files
- ✅ Symlinks via `~/.dotfiles`
- ✅ Follows XDG base directory spec
- ✅ Uses `~/.config` for all CLI tools



## License

MIT — use and adapt freely.
