# ~/.config/zsh/.zshenv
# version: 2026-01-26.4
# purpose: minimal baseline for all zsh invocations
# invariants: no prompts/completions/frameworks; deterministic baseline PATH

export ZDOTDIR="$HOME/.config/zsh"

# Deterministic base PATH, but preserve anything already provided by the parent environment.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"