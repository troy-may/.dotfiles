# Git Hooks for .dotfiles Repository

This directory contains version-controlled git hooks that are automatically installed by `bootstrap.sh`.

## Available Hooks

### pre-commit

Prevents accidental commits of state, cache, history, and secret files that should never be in version control.

**Blocked file patterns:**
- macOS artifacts (`.DS_Store`, `.Trashes`, etc.)
- Shell state (`.zsh_history`, `.bash_history`, `.zsh_sessions/`, etc.)
- Fish shell state (`fish_variables`, `fish_history`)
- Secrets and credentials (`.env`, `.env.*`, `env.*.zsh`, `.secret`, `.key`, `.pem`)
- Editor artifacts (`.swp`, `.swo`, `.vscode/`, `.idea/`)
- Language artifacts (`__pycache__/`, `node_modules/`, etc.)
- Temp/backup files (`.log`, `.bak`, `.tmp`)

**What it does:**
1. Scans all files staged for commit
2. Checks against forbidden patterns
3. Blocks the commit if violations are found
4. Provides helpful error messages and remediation steps

## Installation

The hooks are automatically installed when you run:
```bash
./bootstrap.sh
```

## Manual Installation

If you need to manually install/reinstall the hooks:
```bash
cp hooks/* .git/hooks/
chmod +x .git/hooks/*
```

## Testing

To verify the pre-commit hook is working:
```bash
# This should be blocked by the hook
touch test.DS_Store
git add -f test.DS_Store
git commit -m "Test"  # Will fail with error message
git restore --staged test.DS_Store
rm test.DS_Store
```

## Philosophy

These hooks enforce the repository's core principle: **state, cache, history, and secrets are never committed**. Only configuration files belong in version control.

If the hook blocks a commit, it's protecting the repository's integrity. Don't bypass the hook with `--no-verify` unless you're absolutely certain the file should be committed.
