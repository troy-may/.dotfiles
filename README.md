# .dotfiles
3.3
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
- **`fish`** as the primary interactive shell
- **`zsh`** as a minimal fallback for POSIX compatibility and scripts
- `Starship` for unified prompt rendering across both shells
- `Carapace` for modern command completions in fish

The goal is a **boring, predictable shell environment** with clear boundaries
between config, runtime state, and secrets.

### Why Two Shells?

**Fish (Primary):**
- Built-in syntax highlighting and autosuggestions
- Clearer, more legible syntax
- Better error messages for learning
- Zero framework overhead
- Used for all interactive terminal work

**Zsh (Fallback):**
- POSIX-compatible for scripts with `#!/bin/zsh`
- Available on systems where fish isn't installed
- Minimal configuration, fast startup
- Same aliases and functions as fish

Both shells share:
- Starship prompt (unified appearance)
- Common aliases and utility functions
- Same environment variables
- XDG-compliant configuration structure

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
    ├── fish/                  # Fish shell configuration (primary)
    │   ├── config.fish        # Main fish config (fzf, bat, pyenv, fnm)
    │   ├── functions/         # Fish functions
    │   │   ├── mkcd.fish      # Create directory and cd into it
    │   │   ├── extract.fish   # Extract any archive format
    │   │   ├── backup_dotfiles.fish  # Backup dotfiles directory
    │   │   └── br.fish        # Broot integration (auto-generated)
    │   └── completions/       # Carapace-generated completions
    ├── zsh/                   # Zsh configuration (fallback)
    │   ├── .zshenv            # Path + ZDOTDIR setup
    │   ├── .zshrc             # Main shell config
    │   ├── aliases.zsh        # User-defined aliases
    │   ├── env.zsh            # Shared environment vars (pyenv + fnm)
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
```

---

## Shell Environment Wiring

### Fish Configuration

Fish config lives in `~/.config/fish/config.fish` and includes:
- **PATH configuration (must be first!)** - ensures Homebrew tools are found
- **Starship prompt integration** - unified prompt with custom config path
- **Carapace completions** - modern command descriptions using official initialization
- **fzf integration** - fuzzy finder with Ctrl-T, Ctrl-R, Alt-C key bindings
- **bat integration** - syntax-highlighted file viewing (replaces cat)
- **Environment variables** - XDG paths, editor, locale
- **Basic aliases** - navigation, git shortcuts, utilities

**Critical:** PATH must be configured before initializing Starship or Carapace,
otherwise fish won't find the Homebrew-installed binaries.

**Note:** pyenv and fnm (Fast Node Manager) are now enabled by default and configured
for cross-shell compatibility. Version managers share state between Fish and Zsh.

Fish automatically loads:
- `~/.config/fish/config.fish` (main config)
- `~/.config/fish/functions/*.fish` (function definitions)

No symlinks needed for fish—it respects XDG paths natively.

### Zsh Configuration

Zsh uses `~/.config/zsh/.zshenv` to configure:
- `ZDOTDIR` → forces Zsh to load from `~/.config/zsh`
- `$PATH` → guarantees core macOS binaries are always available

**Required symlink:**
```bash
ln -sf ~/.config/zsh/.zshenv ~/.zshenv
```

Without this, zsh behavior will diverge across login shells, scripts, and tools.

The modular zsh config follows this loading order:
1. `.zshenv` (establishes ZDOTDIR)
2. `.zshrc` (loads all `*.zsh` modules)
3. `env.zsh` (environment variables, PATH, pyenv, nvm)
4. `aliases.zsh` (command aliases)
5. `functions.zsh` (shell functions)
6. `plugins.zsh` (optional enhancements - currently minimal)

### Ghostty Terminal Configuration

Ghostty config lives in `~/.config/ghostty/config` and includes:
- Theme configuration (Catppuccin Mocha to match Starship)
- Font settings (optional)
- Window and behavior preferences

Ghostty respects XDG paths natively—no symlinks needed.

**Custom themes:**
- Location: `~/.config/ghostty/themes/`
- Create custom color schemes as simple config files
- List all themes: `ghostty +list-themes`
- Custom themes show as "(user)" in the theme list

**Theme file format:**
```bash
# Example: ~/.config/ghostty/themes/My Theme
palette = 0=#000000  # Black
palette = 1=#ff0000  # Red
# ... 16 ANSI colors (0-15)
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #f5e0dc
selection-background = #585b70
```

Ghostty will automatically detect themes in the `themes/` directory.

---

## Git Ignore & State Management (Very Important)

This repository is intentionally strict about what is and is not tracked.

### The Rule
- **Configuration** → committed
- **State / cache / history / secrets** → ignored

Because this setup uses XDG paths and symlinks (`~/.config` → `~/.dotfiles/.config`),
runtime artifacts can appear inside the repo path unless explicitly ignored.

The `.gitignore` is therefore **part of the architecture**, not an afterthought.

---

### What Is Ignored (By Design)

**Shell runtime artifacts:**
- `.zcompdump*` (zsh completion cache)
- `.zsh_history` (command history)
- `.zsh_sessions/` (zsh session state)
- `fish_variables` (fish runtime state)

**OS and editor noise:**
- `.DS_Store`
- swap / backup files

**Tool and language caches:**
- `__pycache__/`
- `.venv/`
- `node_modules/`

**Local environment and secrets:**
- All files matching `env.*.zsh` pattern
- Example: `env.anthropic.zsh`, `env.local.zsh`

These files may exist inside the repo path at runtime due to symlinks,
but they must **never be tracked**.

---

### Local Env / Secret Files Pattern

All secrets and machine-specific env vars follow this pattern:

```
~/.config/zsh/env.<name>.zsh
```

Examples:
- `env.anthropic.zsh`
- `env.openai.zsh`
- `env.local.zsh`

These files are always ignored.

If a shared reference is needed, use a template:
```
env.<name>.zsh.example
```

Templates are explicitly allowed by `.gitignore`.

---

### Important Git Behavior (Read Once, Remember Forever)

**`.gitignore` does not affect files that are already tracked.**

If a state or secret file appears in `git status`,
it means it was tracked at some point and must be removed:

```bash
git rm --cached <path>
```

Once removed and committed, `.gitignore` will keep it out permanently.

**If `git status` is noisy, treat it as a diagnostic signal, not annoyance.**

---

## Security Policy (Tiny but Non-Negotiable)

This repository must **never** contain:
- API keys or tokens
- Private keys or certificates
- Shell history
- Session state
- Tool caches

If a secret is accidentally committed:
1. **Rotate or revoke it immediately.**
2. **Assume compromise.**
3. Remove it from git history if necessary.
4. Tighten ignore rules to prevent recurrence.

---

## Git Safety Preflight (Manual Check)

Before committing changes, sanity-check that no forbidden files are tracked:

```bash
git ls-files .config/zsh/.zsh_history
git ls-files .config/zsh/.zcompdump*
git ls-files .config/zsh/.zsh_sessions
git ls-files .config/zsh/env.*.zsh
git ls-files .config/fish/fish_variables
```

These commands should return **no output**.

If they do, untrack the file immediately.

---

## Setup (New Machine)

### 1. System Prerequisites

**Install Xcode Command Line Tools:**
```bash
xcode-select --install
```

**Install Homebrew:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### 2. Clone Dotfiles

```bash
git clone git@github.com:troy-may/.dotfiles.git ~/.dotfiles
```

---

### 3. Install Core Tools

```bash
# Essential shells and tools
brew install fish zsh starship carapace

# Version managers (Python and Node.js)
brew install pyenv fnm

# Optional but recommended (modern CLI tools)
brew install ripgrep fd bat eza zoxide fzf
```

---

### 4. Set Fish as Default Shell

```bash
# Add fish to allowed shells
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

# Set fish as default
chsh -s /opt/homebrew/bin/fish
```

---

### 5. Bootstrap Environment

```bash
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

This will:
- Create symlinks from `~/.config/` → `.dotfiles/.config`
- Install `.zshenv` and enforce `ZDOTDIR`
- Symlink:
  - `~/.zshenv` → `~/.config/zsh/.zshenv`
  - `~/.zshrc` → `~/.config/zsh/.zshrc`
- Set up fish configuration directory

**Restart your terminal afterward.**

---

### 6. Verify Wiring

**For zsh fallback:**
```bash
zsh
echo $ZDOTDIR
ls -la ~/.zshenv
ls -la ~/.zshrc
exit
```

Expected:
- `ZDOTDIR=~/.config/zsh`
- Both files are symlinks into `.dotfiles`

**For fish (primary):**
```bash
fish
echo $EDITOR
type mkcd
which starship carapace
```

Expected:
- `EDITOR=nvim`
- Functions defined
- Tools found in PATH

---

### 7. Add Local Secrets (Never Commit)

**For zsh:**
```bash
touch ~/.config/zsh/env.anthropic.zsh
# Add: export ANTHROPIC_API_KEY="..."
```

**For fish:**
```bash
# Fish uses universal variables for secrets
set -Ux ANTHROPIC_API_KEY "sk-ant-..."
# Or add to a local config file
```

Repeat per provider as needed.

---

### 8. Version Managers (Cross-Shell Compatible)

**pyenv (Python) and fnm (Node.js) are now enabled by default** with cross-shell
compatibility. Both tools work identically in Fish and Zsh, sharing installed versions.

**Architecture:**
- **pyenv**: Uses shims in `~/.pyenv/shims/` that intercept `python` and `pip` commands
- **fnm**: Uses environment PATH manipulation to make Node versions available
- Both store versions in their respective home directories (shared across shells)
- Switching shells maintains the same Python and Node versions

**Already configured in:**
- Fish: `~/.config/fish/config.fish`
- Zsh: `~/.config/zsh/env.zsh`

**To install Python versions:**
```bash
pyenv install 3.12.0
pyenv global 3.12.0
python --version  # Works in both fish and zsh
```

**To install Node versions:**
```bash
fnm install 20        # Install Node 20 LTS
fnm use 20            # Activate Node 20
fnm default 20        # Set as default
node --version        # Works in both fish and zsh
```

**Auto-switching with project files:**
- fnm automatically switches Node versions when you `cd` into a directory with `.node-version` or `.nvmrc`
- pyenv automatically switches Python versions when you `cd` into a directory with `.python-version`

---

### 9. Final Sanity Check

```bash
cd ~/.dotfiles
git status
```

Expected result:
- **Clean working tree**
- Or only intentional config changes

---

## Keeping in Sync Across Machines

To update an existing setup:

```bash
cd ~/.dotfiles
git pull origin main
./bootstrap.sh
```

Re-run bootstrap whenever structure changes.

---

## Daily Workflow

### Interactive Terminal Work (Fish)
```fish
# Use autosuggestions (type and press → to accept)
git status<TAB>    # Carapace completions with descriptions
ll                 # List files
gs                 # git status
mkcd test          # Create and cd into directory
z proj             # Jump to project (if using zoxide)
```

### Running Scripts
Scripts with shebangs run in their specified shell:
```bash
#!/bin/zsh
# This runs in zsh even when called from fish
```

To explicitly use zsh:
```fish
zsh my-script.sh   # Run script in zsh
zsh                # Drop into zsh temporarily
exit               # Return to fish
```

---

## Available Commands (Both Shells)

### Aliases
```bash
# Navigation
..       # cd ..
...      # cd ../..
proj     # cd ~/cli-projects

# Listing
ll       # ls -lah
la       # ls -a

# Git
gs       # git status
ga       # git add
gc       # git commit
gp       # git push
gl       # git pull
gd       # git diff
glog     # git log --oneline --graph

# Editor
vim      # nvim
vi       # nvim
```

### Functions
```bash
mkcd mydir           # Create directory and cd into it
extract file.zip     # Extract any archive format
backup_dotfiles      # Backup dotfiles directory
```

---

## Philosophy

- **Modular and commented configuration**
- **Explicit symlink boundaries**
- **XDG base directory compliance**
- **Clear separation of config vs state vs secrets**
- **Predictable Git behavior**
- **Legible, learnable shell syntax (fish)**
- **POSIX fallback when needed (zsh)**
- **No surprises**

---

## Troubleshooting

### Fish feels unfamiliar
Type `zsh` to drop into zsh temporarily, then `exit` to return to fish.

### Command doesn't work in fish
Most commands work identically. For POSIX-specific syntax:
1. Run in zsh: `zsh -c "your command"`
2. Or create a script with `#!/bin/zsh` shebang

### Want to switch back to zsh as default
```bash
chsh -s /bin/zsh
```

### Starship prompt not showing
```bash
# Check if starship is installed
which starship

# Check config location
ls -la ~/.config/starship/starship.toml

# Verify it's loaded in shell config
cat ~/.config/fish/config.fish | grep starship
```

---

## License

MIT — use, adapt, and simplify freely.

---

## Changelog

### 3.3 (2026-01-07)
- **Added:** fzf (fuzzy finder) integration with official Fish key bindings
- **Added:** bat (syntax-highlighted cat) as default file viewer
- **Improved:** File navigation with Ctrl-T (find files), Ctrl-R (history), Alt-C (directories)
- **Improved:** Enhanced file viewing with automatic syntax highlighting and git integration
- **Changed:** `cat` command now aliases to `bat` (original available as `catt`)

### 3.2 (2026-01-07)
- **Added:** Cross-shell compatible version managers (pyenv + fnm)
- **Breaking:** Replaced nvm with fnm (Fast Node Manager) for Node.js version management
- **Changed:** pyenv now enabled by default in both Fish and Zsh
- **Changed:** fnm replaces nvm - automatically migrates to `.node-version` and `.nvmrc` files
- **Improved:** Version managers now share state between Fish and Zsh shells
- **Improved:** Auto-switching Node/Python versions when entering directories with version files
- **Updated:** Installation instructions include pyenv and fnm in core tools

### 3.1 (2026-01-07)
- **Fixed:** PATH configuration now loads first in fish config (critical for Homebrew tools)
- **Fixed:** Carapace initialization uses official syntax per upstream docs
- **Fixed:** STARSHIP_CONFIG environment variable properly set
- **Changed:** pyenv and nvm disabled by default (adds 100-200ms startup time)
- **Improved:** Complete XDG compliance - all configs properly symlinked
- **Improved:** README documentation updated to match actual working config

### 3.0 (2026-01-06)
- **Breaking:** Switched to fish as primary interactive shell
- **Breaking:** Removed oh-my-zsh dependency (simplified zsh to minimal fallback)
- **Added:** Carapace completion engine for fish
- **Added:** Fish-specific functions (mkcd, extract, backup_dotfiles)
- **Changed:** Starship config simplified to two-line prompt with Mocha theme
- **Changed:** Zsh now serves as POSIX-compatible fallback only
- **Improved:** Shell startup time (~50% faster without oh-my-zsh)
- **Improved:** More legible configuration for novice shell users

### 2.0 (Previous)
- Initial modular setup with oh-my-zsh
- XDG compliance
- Starship prompt integration

---

**This README captures the system and the reasoning behind it — in one place, no hunting required.**
