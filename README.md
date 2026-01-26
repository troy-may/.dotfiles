.dotfiles

3.4.4
📁 Personal dotfiles setup for macOS (and adaptable to Linux).
Clean, modular, XDG-compliant, and deliberately boring.

This repository is the source of truth for my shell and CLI environment.
It is designed to be predictable, portable, and resilient to entropy over time.

⸻

Core Principles
	•	Configuration is version-controlled
	•	State, cache, history, and secrets are never committed
	•	Symlinks are explicit and intentional
	•	If git status is noisy, something is wrong

⸻

Overview

This setup uses:
	•	~/.dotfiles for version-controlled configuration
	•	~/.config/ for XDG-compliant modular layouts
	•	fish as the primary interactive shell
	•	zsh as a minimal fallback for POSIX compatibility and scripts
	•	Starship for unified prompt rendering across both shells
	•	Carapace for modern command completions in fish

The goal is a boring, predictable shell environment with clear boundaries
between config, runtime state, and secrets.

Why Two Shells?

Fish (Primary):
	•	Built-in syntax highlighting and autosuggestions
	•	Clearer, more legible syntax
	•	Better error messages for learning
	•	Zero framework overhead
	•	Used for all interactive terminal work

Zsh (Fallback):
	•	POSIX-compatible for scripts with #!/bin/zsh
	•	Available on systems where fish isn’t installed
	•	Minimal configuration, fast startup
	•	Same aliases and functions as fish (where practical)

Both shells share:
	•	Starship prompt (unified appearance)
	•	Common aliases and utility functions
	•	Same environment variables (where practical)
	•	XDG-compliant configuration structure

⸻

Repository Structure

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
    │   ├── config.fish        # Main fish config (fzf, bat, pyenv, fnm)
    │   ├── functions/         # Fish functions
    │   │   ├── mkcd.fish      # Create directory and cd into it
    │   │   ├── extract.fish   # Extract any archive format
    │   │   ├── backup_dotfiles.fish  # Backup dotfiles directory
    │   │   └── br.fish        # Broot integration (auto-generated)
    │   └── completions/       # Carapace-generated completions
    ├── zsh/                   # Zsh configuration (fallback)
    │   ├── .zprofile          # Login-shell init (macOS Terminal/iTerm/etc)
    │   ├── .zshenv            # ZDOTDIR + base PATH invariants
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

Shell Environment Wiring

Fish Configuration

Fish config lives in ~/.config/fish/config.fish and includes:
	•	PATH configuration (must be first!) - ensures Homebrew tools are found
	•	Starship prompt integration - unified prompt with custom config path
	•	Carapace completions - modern command descriptions using official initialization
	•	fzf integration - fuzzy finder with Ctrl-T, Ctrl-R, Alt-C key bindings
	•	bat integration - syntax-highlighted file viewing (replaces cat)
	•	Environment variables - XDG paths, editor, locale
	•	Basic aliases - navigation, git shortcuts, utilities

Critical: PATH must be configured before initializing Starship or Carapace,
otherwise fish won’t find the Homebrew-installed binaries.

Fish automatically loads:
	•	~/.config/fish/config.fish (main config)
	•	~/.config/fish/functions/*.fish (function definitions)

No symlinks needed for fish—it respects XDG paths natively.

Zsh Configuration

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

Ghostty Terminal Configuration

Ghostty config lives in ~/.config/ghostty/config and includes:
	•	Theme configuration (Catppuccin Mocha to match Starship)
	•	Font settings (optional)
	•	Window and behavior preferences

Ghostty respects XDG paths natively—no symlinks needed.

Custom themes:
	•	Location: ~/.config/ghostty/themes/
	•	Create custom color schemes as simple config files
	•	List all themes: ghostty +list-themes
	•	Custom themes show as “(user)” in the theme list

Theme file format:

# Example: ~/.config/ghostty/themes/My Theme
palette = 0=#000000  # Black
palette = 1=#ff0000  # Red
# ... 16 ANSI colors (0-15)
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #f5e0dc
selection-background = #585b70

Ghostty will automatically detect themes in the themes/ directory.

⸻

Git Ignore & State Management (Very Important)

This repository is intentionally strict about what is and is not tracked.

The Rule
	•	Configuration → committed
	•	State / cache / history / secrets → ignored

Because this setup uses XDG paths and symlinks (~/.config → ~/.dotfiles/.config),
runtime artifacts can appear inside the repo path unless explicitly ignored.

The .gitignore is therefore part of the architecture, not an afterthought.

Automated Protection with Pre-Commit Hook

A pre-commit hook automatically blocks commits containing forbidden files:
	•	macOS artifacts (.DS_Store, .Trashes, etc.)
	•	Shell state/history (.zsh_history, .bash_history, .zsh_sessions/)
	•	Fish state (fish_variables, fish_history)
	•	Secrets (.env, .key, .pem, env.*.zsh)
	•	Editor/IDE artifacts (.vscode/, .idea/, .swp)
	•	Language artifacts (__pycache__/, node_modules/)
	•	Temp/backup files (.log, .bak, .tmp)

The hook provides clear error messages and remediation steps when violations are detected.
It’s installed automatically by bootstrap.sh and cannot be bypassed with git add -f.

See hooks/README.md for full documentation.

⸻

What Is Ignored (By Design)

Shell runtime artifacts:
	•	.zcompdump* (zsh completion cache)
	•	.zsh_history (command history)
	•	.zsh_sessions/ (zsh session state)
	•	fish_variables (fish runtime state)

OS and editor noise:
	•	.DS_Store
	•	swap / backup files

Tool and language caches:
	•	__pycache__/
	•	.venv/
	•	node_modules/

Local environment and secrets:
	•	All files matching env.*.zsh pattern
	•	Example: env.anthropic.zsh, env.local.zsh

AI/ML CLI tools:
	•	.claude/ (Claude Code CLI session data)
	•	.openai/ (OpenAI CLI data)
	•	.codex/ (Codex CLI data)

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

Git Safety Preflight

The pre-commit hook automatically prevents commits of forbidden files, but you can
manually verify that no state/secret files are currently tracked:

git ls-files .config/zsh/.zsh_history
git ls-files .config/zsh/.zcompdump*
git ls-files .config/zsh/.zsh_sessions
git ls-files .config/zsh/env.*.zsh
git ls-files .config/fish/fish_variables

These commands should return no output.

If they do, untrack the file immediately:

git rm --cached <file>


⸻

Setup (New Machine)

1. System Prerequisites

Install Xcode Command Line Tools:

xcode-select --install

Install Homebrew:

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


⸻

2. Clone Dotfiles

git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles


⸻

3. Install Core Tools

# Essential shells and tools
brew install fish zsh starship carapace

# Version managers (Python and Node.js)
brew install pyenv fnm

# Optional but recommended (modern CLI tools)
brew install ripgrep fd bat eza zoxide fzf


⸻

4. Set Fish as Default Shell

# Add fish to allowed shells
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

# Set fish as default
chsh -s /opt/homebrew/bin/fish


⸻

5. Bootstrap Environment

cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh

This will:
	•	Create symlinks from ~/.config/ → .dotfiles/.config
	•	Install git hooks for repository safety (pre-commit)
	•	Install .zshenv and enforce ZDOTDIR
	•	Symlink:
	•	~/.zshenv → ~/.config/zsh/.zshenv
	•	~/.zshrc → ~/.config/zsh/.zshrc
	•	Set up fish configuration directory

Restart your terminal afterward.

⸻

6. Verify Wiring

For zsh fallback:

zsh
echo $ZDOTDIR
ls -la ~/.zshenv
ls -la ~/.zshrc
exit

Expected:
	•	ZDOTDIR=~/.config/zsh
	•	Both files are symlinks into .dotfiles

For fish (primary):

fish
echo $EDITOR
type mkcd
which starship carapace

Expected:
	•	EDITOR=nvim
	•	Functions defined
	•	Tools found in PATH

⸻

Keeping in Sync Across Machines

To update an existing setup:

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
	•	Fixed: Hardcoded username path in .zshrc replaced with $HOME variable
	•	Improved: Better portability across machines

3.4.1 (2026-01-08)
	•	Fixed: Regex patterns in pre-commit hook (removed invalid leading asterisks)
	•	Fixed: Hook now runs without grep errors

3.4 (2026-01-08)
	•	Added: Git pre-commit hook to automatically prevent commits of state/secret files
	•	Added: hooks/ directory with version-controlled pre-commit hook
	•	Added: Comprehensive protection against committing forbidden files
	•	Updated: bootstrap.sh now automatically installs git hooks
	•	Improved: Clear error messages and remediation steps when violations detected
	•	Security: Hook cannot be bypassed with git add -f

3.3.3 (2026-01-08)
	•	Fixed: Removed accidentally tracked .DS_Store and zsh session files from repository
	•	Fixed: Updated .gitignore with correct path pattern for zsh sessions
	•	Cleaned: Removed 7 state/cache files from git tracking (kept locally)

3.3.2 (2026-01-07)
	•	Fixed: Ghostty Option key now sends Alt/Meta for fzf Alt-C keybinding
	•	Added: fzf preview with bat (shows file contents in right pane)
	•	Improved: Better fzf defaults (border, reverse layout, inline info)
	•	Note: Requires Ghostty restart for Option key fix to take effect

3.3.1 (2026-01-07)
	•	Fixed: Critical bug - renamed path alias to showpath to avoid conflict with Fish builtin
	•	Fixed: fzf integration was broken due to path builtin override causing tr errors
	•	Note: Fish has a built-in path command used for path manipulation - don’t override it!

3.3 (2026-01-07)
	•	Added: fzf (fuzzy finder) integration with official Fish key bindings
	•	Added: bat (syntax-highlighted cat) as default file viewer
	•	Improved: File navigation with Ctrl-T (find files), Ctrl-R (history), Alt-C (directories)
	•	Improved: Enhanced file viewing with automatic syntax highlighting and git integration
	•	Changed: cat command now aliases to bat (original available as catt)

3.2 (2026-01-07)
	•	Added: Cross-shell compatible version managers (pyenv + fnm)
	•	Breaking: Replaced nvm with fnm (Fast Node Manager) for Node.js version management
	•	Changed: pyenv now enabled by default in both Fish and Zsh
	•	Changed: fnm replaces nvm - automatically migrates to .node-version and .nvmrc files
	•	Improved: Version managers now share state between Fish and Zsh shells
	•	Improved: Auto-switching Node/Python versions when entering directories with version files
	•	Updated: Installation instructions include pyenv and fnm in core tools

3.1 (2026-01-07)
	•	Fixed: PATH configuration now loads first in fish config (critical for Homebrew tools)
	•	Fixed: Carapace initialization uses official syntax per upstream docs
	•	Fixed: STARSHIP_CONFIG environment variable properly set
	•	Changed: pyenv and nvm disabled by default (adds 100-200ms startup time)
	•	Improved: Complete XDG compliance - all configs properly symlinked
	•	Improved: README documentation updated to match actual working config

3.0 (2026-01-06)
	•	Breaking: Switched to fish as primary interactive shell
	•	Breaking: Removed oh-my-zsh dependency (simplified zsh to minimal fallback)
	•	Added: Carapace completion engine for fish
	•	Added: Fish-specific functions (mkcd, extract, backup_dotfiles)
	•	Changed: Starship config simplified to two-line prompt with Mocha theme
	•	Changed: Zsh now serves as POSIX-compatible fallback only
	•	Improved: Shell startup time (~50% faster without oh-my-zsh)
	•	Improved: More legible configuration for novice shell users

2.0 (Previous)
	•	Initial modular setup with oh-my-zsh
	•	XDG compliance
	•	Starship prompt integration

⸻

This README captures the system and the reasoning behind it — in one place, no hunting required.