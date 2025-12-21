# .dotfiles
2.1  
📁 Personal dotfiles setup for macOS (and adaptable to Linux). Clean, modular, and XDG-compliant.

## Overview

This setup uses:

- `~/.dotfiles` for version-controlled configuration
- `~/.config/` for XDG-compliant modular layouts
- `Oh My Zsh` as the plugin loader
- `Starship` for prompt rendering
- `.zshenv` to establish a safe, portable environment for all shells
  (interactive, login, and non-interactive)

The goal is a **boring, predictable, portable shell environment** that cleanly
separates configuration from runtime state and secrets.

---

## Structure

.dotfiles/
├── bootstrap.sh               # Bootstrap: install symlinks and .zshenv
├── preflight.sh               # Audit environment (ZDOTDIR, PATH, symlinks)
├── README.md                  # This file – explains setup and structure
├── .gitignore                 # Enforces config vs state vs secrets boundary
└── .config/                   # XDG-compliant configuration directory
├── zsh/                   # Modular Zsh setup
│   ├── .zshenv            # Path and ZDOTDIR setup (dotfile required)
│   ├── .zshrc             # Main config, sourced via symlink from ~/
│   ├── aliases.zsh        # User-defined aliases
│   ├── env.zsh            # Non-secret shared environment variables
│   ├── plugins.zsh        # Plugin declarations (OMZ plugins=() list)
│   └── functions.zsh      # Custom shell functions
├── starship/              # Starship prompt config
│   └── starship.toml
└── wezterm/               # (Optional) WezTerm terminal config
└── wezterm.lua

---

## Zsh Environment Setup

This dotfiles repo uses `~/.config/zsh/.zshenv` to configure:

- `ZDOTDIR` → redirects Zsh to load config from `~/.config/zsh`
- `$PATH` → ensures core macOS binary locations are always available
  (`grep`, `uname`, etc.)

### Example: `.zshenv` contents

```zsh
# ~/.config/zsh/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

✅ You must symlink this to ~/.zshenv for reliable shell behavior:

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

This ensures the environment is correct for:
	•	login shells
	•	interactive shells
	•	scripts
	•	subshells

⸻

Git Ignore & State Management (Important)

This repository is intentionally strict about what is and is not tracked.

Core Principle
	•	Configuration is version-controlled
	•	State, cache, history, and secrets are never committed

Because this setup uses XDG paths and symlinks
(~/.config → ~/.dotfiles/.config),
runtime artifacts can appear inside the git repository path unless they are
explicitly ignored.

The .gitignore is therefore a first-class part of the system design.

What Is Ignored (By Design)

The following classes of files are always ignored:
	•	Zsh runtime artifacts:
	•	.zcompdump*
	•	.zsh_history
	•	.zsh_sessions/
	•	Editor and OS noise:
	•	.DS_Store
	•	swap / backup files
	•	Language and tool caches:
	•	__pycache__/, .venv/, node_modules/, etc.
	•	Local environment files and secrets

These files may exist inside the repo path at runtime due to symlinks,
but they are never meant to be tracked.

Local Env Files Pattern

Local, secret, or machine-specific environment files follow this pattern:

~/.config/zsh/env.<name>.zsh

Examples:
	•	env.anthropic.zsh
	•	env.openai.zsh
	•	env.local.zsh

These files are always ignored.

If a shared template is needed, use:

env.<name>.zsh.example

Templates are explicitly allowed by .gitignore.

Important Git Behavior Note

.gitignore does not affect files that are already tracked.

If a state or secret file ever appears in git status, it means it was
tracked at some point and must be removed with:

git rm --cached <path>

After that, .gitignore will keep it out permanently.

Summary
	•	If git status is noisy, something is violating the config/state boundary
	•	The .gitignore is part of the architecture, not an afterthought
	•	Treat it as a maintenance-critical file

⸻

Setup

1. Clone the repo

git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles

2. Run the bootstrap script

cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh

This will:
	•	Create symlinks from ~/.config/ to .dotfiles/.config
	•	Install .zshenv with stable PATH and ZDOTDIR logic
	•	Symlink ~/.zshenv → ~/.config/zsh/.zshenv
	•	Symlink ~/.zshrc → ~/.config/zsh/.zshrc if present

3. Restart your terminal

⸻

Optional: Run Preflight Audit

Before or after running bootstrap, you can run a dry-check of your system:

cd ~/.dotfiles
chmod +x preflight.sh
./preflight.sh

It verifies:
	•	ZDOTDIR is set correctly
	•	.zshenv and .zshrc symlinks are valid
	•	Core macOS binary paths are present in $PATH
	•	Shell essentials (grep, uname, sw_vers, file) are usable

⸻

Tools in Use
	•	Oh My Zsh￼
	•	Starship Prompt￼
	•	Homebrew￼
	•	tmux￼

⸻

Optional: Install Recommended CLI Tools (macOS)

brew install starship zoxide eza bat fzf ripgrep fd tmux

Tool Descriptions

Tool	Purpose
starship	Fast, cross-shell prompt
zoxide	Smart directory jumper
eza	Modern ls replacement
bat	Syntax-highlighted cat
fzf	Fuzzy finder
ripgrep	Fast recursive grep
fd	Simpler find
tmux	Terminal multiplexer


⸻

Keeping in Sync Across Machines

To use this setup on another machine:

git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh

To update later:

cd ~/.dotfiles
git pull origin main
./bootstrap.sh


⸻

Optional: Sharing History or Scripts

Private items like history or personal scripts should be synced explicitly:

rsync -avz ~/.zsh_history your-laptop.local:~/
rsync -avz ~/.local/bin/ your-laptop.local:~/.local/bin/


⸻

Line Endings and File Consistency

This repo uses .gitattributes to normalize line endings:
	•	All text files use LF (Unix-style)
	•	Prevents cross-platform diff and execution issues
	•	Binary files are excluded

⸻

Philosophy
	•	✅ Modular, commented configuration
	•	✅ Explicit symlink boundaries
	•	✅ XDG base directory compliance
	•	✅ Clear separation of config vs state vs secrets
	•	✅ Predictable git status

⸻

License

MIT — use and adapt freely.

---

This README now **explains the system**, including some hard-won edge cases.