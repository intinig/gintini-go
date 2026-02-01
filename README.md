# gintini-go

A two-stage macOS bootstrap system for quickly setting up a fresh Mac.

## How It Works

1. **Stage 1 (this repo)**: Run on a fresh Mac before GitHub authentication. Installs the essentials: Xcode CLI tools, Homebrew, git, and gh.
2. **Stage 2 (private repo)**: Run after `gh auth login`. Installs your apps, clones dotfiles, and configures your full environment.

## Quick Start

### Stage 1: Fresh Mac Setup

```bash
curl -fsSL https://raw.githubusercontent.com/intinig/gintini-go/main/mac.sh | bash
```

This installs:
- Xcode Command Line Tools
- Homebrew
- git
- git-credential-manager
- gh (GitHub CLI)

### Stage 2: After GitHub Auth

```bash
gh auth login
gh repo clone intinig/gintini-go-private /tmp/gintini-go-private && /tmp/gintini-go-private/mac.sh
```

## Features

- **Idempotent**: Safe to run multiple times
- **Non-interactive**: Minimal prompts (only Xcode CLI tools requires user confirmation)
- **Apple Silicon & Intel**: Works on both architectures
- **Clear logging**: All output prefixed with `[gintini-go]`

## License

MIT
