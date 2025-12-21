# .dotfiles
2.0  
📁 Personal dotfiles setup for macOS (and adaptable to Linux).  
Clean, modular, XDG-compliant, and deliberately boring.

This repository is the **source of truth** for my shell and CLI environment.
It is designed to be predictable, portable, and resilient to entropy over time.

---

## Core Principles

- **Configuration is version-controlled**
- **State, cache, history, and secrets are never committed**
- **Symlinks are explicit and intentional**
- **If `git status` is noisy, something is wrong**

---

## Overview

This setup uses:

- `~/.dotfiles` for version-controlled configuration
- `~/.config/` for XDG-compliant modular layouts
- `Oh My Zsh` as the plugin loader
- `Starship` for prompt rendering
- `.zshenv` to establish a safe, portable environment for:
  - login shells
  - interactive shells
  - scripts
  - subshells

The goal is a **boring, predictable shell environment** with clear boundaries
between config, runtime state, and secrets.

---

## Repository Structure
```
.dotfiles/
├── bootstrap.sh               # Install symlinks and base shell wiring
├── preflight.sh               # Audit environment (ZDOTDIR, PATH, symlinks)
├── README.md                  # This file (authoritative documentation)
├── .gitignore                 # Enforces config vs state vs secrets boundary
├── .gitattributes             # Line ending normalization
└── .config/                   # XDG-compliant configuration directory
├── zsh/                   # Modular Zsh setup
│   ├── .zshenv            # Path + ZDOTDIR setup (dotfile)
│   ├── .zshrc             # Main shell config (symlinked from ~/)
│   ├── aliases.zsh        # User-defined aliases
│   ├── env.zsh            # Shared, non-secret environment vars
│   ├── plugins.zsh        # OMZ plugin declarations
│   └── functions.zsh      # Custom shell functions
├── starship/
│   └── starship.toml      # Prompt configuration
└── wezterm/               # Optional terminal config
└── wezterm.lua
```
---

## Zsh Environment Wiring (Critical)

This repo uses `~/.config/zsh/.zshenv` to configure:

- `ZDOTDIR` → forces Zsh to load from `~/.config/zsh`
- `$PATH` → guarantees core macOS binaries are always available

### Example `.zshenv`

```zsh
# ~/.config/zsh/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

Required symlink

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

Without this, behavior will diverge across login shells, scripts, and tools.

⸻

Git Ignore & State Management (Very Important)

This repository is intentionally strict about what is and is not tracked.

The Rule
	•	Configuration → committed
	•	State / cache / history / secrets → ignored

Because this setup uses XDG paths and symlinks
(~/.config → ~/.dotfiles/.config),
runtime artifacts can appear inside the repo path unless explicitly ignored.

The .gitignore is therefore part of the architecture, not an afterthought.

⸻

What Is Ignored (By Design)
	•	Zsh runtime artifacts
	•	.zcompdump*
	•	.zsh_history
	•	.zsh_sessions/
	•	OS and editor noise
	•	.DS_Store
	•	swap / backup files
	•	Tool and language caches
	•	__pycache__/
	•	.venv/
	•	node_modules/
	•	Local environment and secrets

These files may exist inside the repo path at runtime due to symlinks,
but they must never be tracked.

⸻

Local Env / Secret Files Pattern

All secrets and machine-specific env vars follow this pattern:

~/.config/zsh/env.<name>.zsh

Examples:
	•	env.anthropic.zsh
	•	env.openai.zsh
	•	env.local.zsh

These files are always ignored.

If a shared reference is needed, use a template:

env.<name>.zsh.example

Templates are explicitly allowed by .gitignore.

⸻

Important Git Behavior (Read Once, Remember Forever)

.gitignore does not affect files that are already tracked.

If a state or secret file appears in git status,
it means it was tracked at some point and must be removed:

git rm --cached <path>

Once removed and committed, .gitignore will keep it out permanently.

If git status is noisy, treat it as a diagnostic signal, not annoyance.

⸻

Security Policy (Tiny but Non-Negotiable)

This repository must never contain:
	•	API keys or tokens
	•	Private keys or certificates
	•	Shell history
	•	Session state
	•	Tool caches

If a secret is accidentally committed:
	1.	Rotate or revoke it immediately.
	2.	Assume compromise.
	3.	Remove it from git history if necessary.
	4.	Tighten ignore rules to prevent recurrence.

⸻

Git Safety Preflight (Manual Check)

Before committing changes, sanity-check that no forbidden files are tracked:

git ls-files .config/zsh/.zsh_history
git ls-files .config/zsh/.zcompdump*
git ls-files .config/zsh/.zsh_sessions
git ls-files .config/zsh/env.*.zsh

These commands should return no output.

If they do, untrack the file immediately.

⸻

Setup (New Machine)

1. System prerequisites
	•	Install Xcode Command Line Tools

xcode-select --install


	•	Install Homebrew
https://brew.sh

⸻

2. Clone dotfiles

git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles


⸻

3. Bootstrap environment

cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh

This will:
	•	Create symlinks from ~/.config/ → .dotfiles/.config
	•	Install .zshenv and enforce ZDOTDIR
	•	Symlink:
	•	~/.zshenv → ~/.config/zsh/.zshenv
	•	~/.zshrc → ~/.config/zsh/.zshrc

Restart the terminal afterward.

⸻

4. Verify wiring

echo $ZDOTDIR
ls -la ~/.zshenv
ls -la ~/.zshrc

Expected:
	•	ZDOTDIR=~/.config/zsh
	•	Both files are symlinks into .dotfiles

⸻

5. Add local secrets (never commit)

touch ~/.config/zsh/env.anthropic.zsh

Repeat per provider as needed.

⸻

6. Install baseline CLI tools (optional)

brew install starship zoxide eza bat fzf ripgrep fd tmux


⸻

7. Final sanity check

git status

Expected result:
	•	clean working tree
	•	or only intentional config changes

⸻

Keeping in Sync Across Machines

To update an existing setup:

cd ~/.dotfiles
git pull origin main
./bootstrap.sh

Re-run bootstrap whenever structure changes.

⸻

Philosophy
	•	Modular and commented configuration
	•	Explicit symlink boundaries
	•	XDG base directory compliance
	•	Clear separation of config vs state vs secrets
	•	Predictable Git behavior
	•	No surprises

⸻

License

MIT — use, adapt, and simplify freely.

---
This README now **captures the system** and the reasoning behind it — in one place,
no hunting required, including some hard-won edge cases.