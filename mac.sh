#!/bin/bash
# gintini-go: Public macOS bootstrap script
# Purpose: Bootstrap a fresh Mac to the point where GitHub auth works
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/intinig/gintini-go/main/mac.sh)"

set -euo pipefail

# Wrap in main() to prevent curl|bash race condition
main() {
    # Trap to log where failures occur
    trap 'echo "[gintini-go] ERROR: Script failed at line $LINENO" >&2' ERR

    log() {
        echo "[gintini-go] $1"
    }

    install_formula() {
        local formula=$1
        if brew list --formula | grep -q "^${formula}$"; then
            log "$formula already installed."
        else
            log "Installing $formula..."
            brew install "$formula"
        fi
    }

    # Step 1: Check/install Xcode Command Line Tools
    log "Checking Xcode Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        log "Installing Xcode Command Line Tools..."
        xcode-select --install

        log "Waiting for Xcode Command Line Tools installation to complete..."
        log "Please complete the installation in the popup window."

        # Wait for installation to complete
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        log "Xcode Command Line Tools installed successfully."
    else
        log "Xcode Command Line Tools already installed."
    fi

    # Step 2: Check/install Homebrew
    log "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        log "Homebrew installed successfully."
    else
        log "Homebrew already installed."
    fi

    # Step 3: Source Homebrew into current shell (critical for fresh installs)
    log "Configuring Homebrew in current shell..."
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Step 4: Install git, git-credential-manager, and gh
    log "Installing git tools..."

    install_formula git
    install_formula git-credential-manager
    install_formula gh

    log "Public bootstrap complete!"
    echo ""
    echo "=========================================="
    echo "Next steps:"
    echo "1. Run: gh auth login"
    echo "2. Then: gh repo clone intinig/gintini-go-private /tmp/gintini-go-private && /tmp/gintini-go-private/mac.sh"
    echo "=========================================="
}

main "$@"
