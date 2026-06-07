# ==============================================================================
# FILE: .profile
# DESCRIPTION: The engine room for environment variables and PATH setup.
#              Sourced by both Zsh and Bash login shells. Uses idempotent
#              helper functions to securely prepend binary directories (Go, Rust,
#              Node, Homebrew, Antigravity) to the PATH without duplication.
# ==============================================================================

# Idempotency guard: Prevent double-sourcing in macOS login shells
if [ -n "$PROFILE_LOADED" ]; then
    return
fi
export PROFILE_LOADED=1

# 1. Initialize Homebrew environment (Intel/ARM agnostic)
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Helper function to prepend a directory to PATH if it exists and is not already in PATH
path_prepend() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
            *":$1:"*) ;;
            *) export PATH="$1:$PATH" ;;
        esac
    fi
}

# Helper function to append a directory to PATH if it exists and is not already in PATH
path_append() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
            *":$1:"*) ;;
            *) export PATH="$PATH:$1" ;;
        esac
    fi
}

# --- Go ---
path_append "/usr/local/go/bin"

# --- Elan (Lean Version Manager) ---
path_prepend "$HOME/.elan/bin"

# --- Rust / Cargo ---
path_prepend "$HOME/.cargo/bin"

# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

# --- Local Binaries ---
path_prepend "$HOME/.local/bin"

# --- Antigravity CLI and IDE ---
path_prepend "$HOME/.antigravity/antigravity/bin"
path_prepend "$HOME/.antigravity-ide/antigravity-ide/bin"

# --- Source interactive bash settings if running bash ---
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
