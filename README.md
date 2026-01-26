# .dotfiles

**v3.4.4**  
Personal dotfiles setup for macOS (adaptable to Linux).  
Clean, modular, XDG-compliant, and deliberately boring.

This repository is the source of truth for my shell and CLI environment.  
It is designed to be predictable, portable, and resilient to entropy over time.

---

## Core principles

- Configuration is version-controlled
- State, cache, history, and secrets are never committed
- Symlinks are explicit and intentional
- If `git status` is noisy, something is wrong

---

## Overview

This setup uses:

- `~/.dotfiles` for version-controlled configuration
- `~/.config/` for XDG-compliant modular layouts
- **fish** as the primary interactive shell
- **zsh** as a minimal fallback for POSIX compatibility and legacy scripts
- **Starship** for unified prompt rendering across both shells
- **Carapace** for modern completions (especially in fish)

The goal is a boring, predictable shell environment with clear boundaries between:

- config (tracked)
- runtime state (ignored)
- secrets (ignored)

---

## Why two shells?

### Fish (primary)

- Built-in syntax highlighting and autosuggestions
- Clearer, more legible syntax
- Better error messages for learning
- Zero framework overhead
- Used for all interactive terminal work

### Zsh (fallback)

- POSIX-friendly for scripts and compatibility
- Available on systems where fish isn’t installed
- Minimal configuration, fast startup
- Shared mental model with fish (Starship prompt, similar tools)

### Shared across both

- Starship prompt (unified appearance)
- Common environment expectations (where practical)
- XDG-compliant structure

---

## Repository structure

```text
.dotfiles/
├── bootstrap.sh               # Install symlinks and base shell wiring
├── preflight.sh               # Audit environment (ZDOTDIR, PATH, symlinks)
├── README.md                  # This file (authoritative documentation)
├── .gitignore                 # Enforces config vs state vs secrets boundary
├── .gitattributes             # Line ending normalization
├── .zshrc                     # Stub delegating to ~/.config/zsh/.zshrc
├── hooks/                     # Git hooks for repository safety
│   ├── pre-commit             # Prevents committing state/secret files
│   └── README.md              # Hook documentation
└── .config/                   # XDG-compliant configuration directory
    ├── fish/                  # Fish shell configuration (primary)
    │   ├── config.fish        # Main fish config
    │   ├── functions/         # Fish functions
    │   │   ├── mkcd.fish
    │   │   ├── extract.fish
    │   │   ├── backup_dotfiles.fish
    │   │   └── br.fish        # Broot integration (auto-generated)
    │   └── completions/       # Carapace-generated completions
    ├── zsh/                   # Zsh configuration (fallback)
    │   ├── .zprofile          # Login-shell init (macOS Terminal/iTerm/etc)
    │   ├── .zshenv            # ZDOTDIR + base invariants
    │   ├── .zshrc             # Interactive zsh config (completion, prompt, tools)
    │   ├── aliases.zsh        # User-defined aliases
    │   ├── plugins.zsh        # Optional zsh enhancements
    │   └── functions.zsh      # Custom shell functions
    ├── starship/
    │   └── starship.toml      # Unified prompt configuration
    ├── ghostty/
    │   ├── config             # Terminal emulator configuration
    │   └── themes/            # Custom color schemes
    │       └── My Custom Dark # Example custom theme
    └── aerospace/
        └── aerospace.toml     # AeroSpace tiling window manager config


⸻

Shell environment wiring

Fish configuration

Fish config lives at:
	•	~/.config/fish/config.fish

It includes:
	•	PATH configuration (must be first)
	•	Starship prompt integration
	•	Carapace completions (official init)
	•	fzf integration (Ctrl-T / Ctrl-R / Alt-C)
	•	bat integration (better cat)
	•	environment variables (XDG paths, editor, locale)
	•	basic aliases (navigation, git shortcuts, utilities)

Fish automatically loads:
	•	~/.config/fish/config.fish
	•	~/.config/fish/functions/*.fish

No symlinks needed for fish — it respects XDG paths natively.

Critical: PATH must be configured before initializing Starship or Carapace, otherwise fish won’t find Homebrew-installed binaries.

⸻

Zsh configuration

Zsh is wired so that:
	•	~/.zshenv is the required entry point (login shells + scripts)
	•	ZDOTDIR=~/.config/zsh forces zsh to load everything from XDG config
	•	~/.zshrc is a tiny stub that delegates to ~/.config/zsh/.zshrc
(so tools that insist on ~/.zshrc still behave correctly)

Required symlink:

ln -sf ~/.config/zsh/.zshenv ~/.zshenv

Without this, zsh behavior will diverge across login shells, scripts, and tools.

Loading order (simplified):
	1.	~/.zshenv → sets ZDOTDIR
	2.	~/.config/zsh/.zprofile → login shell setup (macOS GUI terminals)
	3.	~/.config/zsh/.zshrc → interactive config (completion, prompt, tools)
	4.	~/.config/zsh/aliases.zsh / functions.zsh / plugins.zsh → modular extras

⸻

Ghostty terminal configuration

Ghostty config lives at:
	•	~/.config/ghostty/config

Custom themes:
	•	~/.config/ghostty/themes/

Useful commands:
	•	List themes: ghostty +list-themes

Theme file format:

# Example: ~/.config/ghostty/themes/My Theme
palette = 0=#000000
palette = 1=#ff0000
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #f5e0dc
selection-background = #585b70

Ghostty respects XDG paths natively — no symlinks needed.

⸻

Git ignore & state management (very important)

This repository is intentionally strict about what is and is not tracked.

The rule
	•	Configuration → committed
	•	State / cache / history / secrets → ignored

Because this setup uses XDG paths and symlinks (~/.config → ~/.dotfiles/.config), runtime artifacts can appear inside the repo path unless explicitly ignored.

.gitignore is part of the architecture, not an afterthought.

⸻

Automated protection with pre-commit hook

A pre-commit hook blocks commits containing forbidden files, including:
	•	macOS artifacts (.DS_Store, .Trashes, etc.)
	•	shell history/state (.zsh_history, .zsh_sessions/, etc.)
	•	fish runtime state (fish_variables, fish_history)
	•	secrets (.env, .key, .pem, env.*.zsh)
	•	editor/IDE artifacts (.vscode/, .idea/, swap files)
	•	language artifacts (__pycache__/, node_modules/)
	•	temp/backup files (.log, .bak, .tmp)
	•	AI tool session directories (.claude/, .openai/, .codex/)

The hook provides clear error messages and remediation steps when violations are detected.

See hooks/README.md for details.

⸻

What is ignored (by design)

Shell runtime artifacts:
	•	.zcompdump*
	•	.zsh_history
	•	.zsh_sessions/
	•	fish_variables
	•	fish_history

OS and editor noise:
	•	.DS_Store
	•	swap / backup files

Tool and language caches:
	•	__pycache__/
	•	.venv/
	•	node_modules/

Local environment and secrets:
	•	env.*.zsh (example: env.anthropic.zsh, env.local.zsh)

AI/ML CLI tools:
	•	.claude/
	•	.openai/
	•	.codex/

These may exist inside the repo path at runtime due to symlinks, but they must never be tracked.

⸻

Local env / secret files pattern

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

Security policy (tiny but non-negotiable)

This repository must never contain:
	•	API keys or tokens
	•	private keys or certificates
	•	shell history
	•	session state
	•	tool caches

If a secret is accidentally committed:
	1.	Rotate or revoke it immediately
	2.	Assume compromise
	3.	Remove it from git history if necessary
	4.	Tighten ignore rules to prevent recurrence

⸻

Important git behavior (read once)

.gitignore does not affect files that are already tracked.

If a state or secret file appears in git status, it was tracked at some point and must be untracked:

git rm --cached <path>

Once removed and committed, .gitignore will keep it out permanently.

If git status is noisy, treat it as a diagnostic signal, not annoyance.

⸻

Git safety preflight

These commands should return no output:

git ls-files .config/zsh/.zsh_history
git ls-files .config/zsh/.zcompdump*
git ls-files .config/zsh/.zsh_sessions
git ls-files .config/zsh/env.*.zsh
git ls-files .config/fish/fish_variables

If any return results, untrack immediately:

git rm --cached <file>


⸻

Setup (new machine)

1) System prerequisites

Install Xcode Command Line Tools:

xcode-select --install

Install Homebrew:

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


⸻

2) Clone dotfiles

git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles


⸻

3) Install core tools

Essential shells and tools:

brew install fish zsh starship carapace

Version managers:

brew install pyenv fnm

Optional but recommended:

brew install ripgrep fd bat eza zoxide fzf


⸻

4) Set fish as default shell

Add fish to allowed shells:

echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

Set fish as default:

chsh -s /opt/homebrew/bin/fish


⸻

5) Bootstrap environment

cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh

This will:
	•	create symlinks from ~/.config/ → ~/.dotfiles/.config
	•	install git hooks for repository safety (pre-commit)
	•	install .zshenv and enforce ZDOTDIR
	•	ensure zsh loads XDG config consistently

Restart your terminal afterward.

⸻

6) Verify wiring

Zsh fallback:

zsh
echo $ZDOTDIR
ls -la ~/.zshenv
ls -la ~/.zshrc
exit

Expected:
	•	ZDOTDIR=~/.config/zsh
	•	~/.zshenv exists and points to XDG config
	•	~/.zshrc is a stub delegating to ~/.config/zsh/.zshrc

Fish primary:

fish
echo $EDITOR
type mkcd
which starship carapace

Expected:
	•	EDITOR=nvim
	•	functions defined
	•	tools found in PATH

⸻

Keeping in sync across machines

Update an existing setup:

cd ~/.dotfiles
git pull origin main
./bootstrap.sh

Re-run bootstrap whenever structure changes.

⸻

License

MIT — use, adapt, and simplify freely.

⸻

Changelog

3.4.4 (2026-01-26)
	•	Added: ~/.config/zsh/.zprofile for login-shell initialization
	•	Changed: ~/.zshrc is now a minimal stub delegating to ~/.config/zsh/.zshrc
	•	Fixed: Fish Carapace initialization to enable rich completions and descriptions
	•	Improved: Zsh completion behavior (menu selection + predictable narrowing)

3.4.3 (2026-01-08)
	•	Added: AI/ML CLI tool directories to gitignore (.claude/, .openai/, .codex/)
	•	Updated: Pre-commit hook to block these session data directories
	•	Improved: Protection against accidentally committing Claude Code, OpenAI, and Codex session files

3.4.2 (2026-01-08)
	•	Fixed: Hardcoded username path in .zshrc replaced with $HOME
	•	Improved: Better portability across machines

3.4.1 (2026-01-08)
	•	Fixed: Regex patterns in pre-commit hook (removed invalid leading asterisks)
	•	Fixed: Hook now runs without grep errors

3.4 (2026-01-08)
	•	Added: Git pre-commit hook to automatically prevent commits of state/secret files
	•	Added: hooks/ directory with version-controlled pre-commit hook
	•	Added: Comprehensive protection against committing forbidden files
	•	Updated: bootstrap.sh installs git hooks
	•	Improved: Clear error messages and remediation steps when violations detected

3.3.3 (2026-01-08)
	•	Fixed: Removed accidentally tracked .DS_Store and zsh session files from repository
	•	Fixed: Updated .gitignore with correct path pattern for zsh sessions

3.3.2 (2026-01-07)
	•	Fixed: Ghostty Option key sends Alt/Meta for fzf Alt-C
	•	Added: fzf preview with bat
	•	Improved: Better fzf defaults

3.3.1 (2026-01-07)
	•	Fixed: Renamed path alias to showpath to avoid conflict with Fish builtin

3.3 (2026-01-07)
	•	Added: fzf integration with official Fish key bindings
	•	Added: bat as default file viewer
	•	Improved: File navigation and preview workflow

3.2 (2026-01-07)
	•	Added: pyenv + fnm
	•	Breaking: Replaced nvm with fnm
	•	Improved: Version managers share state between fish and zsh

3.1 (2026-01-07)
	•	Fixed: PATH loads first in fish config
	•	Fixed: Carapace initialization uses official syntax
	•	Improved: README updated to match working config

3.0 (2026-01-06)
	•	Breaking: Switched to fish as primary interactive shell
	•	Breaking: Removed oh-my-zsh dependency
	•	Added: Carapace completion engine for fish

2.0 (previous)
	•	Initial modular setup
	•	XDG compliance
	•	Starship prompt integration

If you want, I can also rewrite `bootstrap.sh` comments to match this README (so the repo stays “single source of truth” everywhere).