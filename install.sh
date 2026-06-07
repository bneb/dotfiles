#!/usr/bin/env bash

# ==============================================================================
# FILE: install.sh
# DESCRIPTION: The master deployment script for the dotfiles architecture.
#              Safely installs Homebrew, parses the Brewfile for dependencies,
#              downloads external themes, symlinks the environment, and creates
#              the local secrets skeleton.
# EXECUTION: This script is idempotent and can be run multiple times safely.
# ==============================================================================

set -e

echo "Starting installation..."

if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Do not run this script as root."
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Ensure brew is available in our current session PATH
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Install Homebrew packages via Brewfile
echo "Installing dependencies via Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile" || echo "Warning: Some Brew packages failed to install."

# Set Chrome as default browser
echo "Setting Google Chrome as default browser..."
defaultbrowser chrome || true

# 3. Create necessary directories
echo "Creating ~/.config directories..."
mkdir -p "$HOME/.config/alacritty"

# 4. Download External Themes
if [ ! -f "$DOTFILES_DIR/catppuccin-mocha.toml" ]; then
    echo "Downloading Catppuccin Mocha theme..."
    curl -fsSLo "$DOTFILES_DIR/catppuccin-mocha.toml" https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.toml
fi

# 5. Create symlinks for dotfiles
echo "Creating symlinks..."

HOME_FILES=(".zshrc" ".bashrc" ".profile" ".tmux.conf" ".gitconfig" ".zprofile" ".gitignore_global")

for file in "${HOME_FILES[@]}"; do
    TARGET="$HOME/$file"
    SOURCE="$DOTFILES_DIR/$file"
    
    if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        BACKUP_FILE="${TARGET}.bak.$(date +%s)"
        echo "Warning: $TARGET exists. Backing up to $BACKUP_FILE..."
        mv "$TARGET" "$BACKUP_FILE"
    fi
    
    ln -sf "$SOURCE" "$TARGET"
    echo "Symlinked $file"
done

# Symlink configs to .config
CONFIG_FILES=(
    "starship.toml:$HOME/.config/starship.toml"
    "alacritty.toml:$HOME/.config/alacritty/alacritty.toml"
    "catppuccin-mocha.toml:$HOME/.config/alacritty/catppuccin-mocha.toml"
)

for mapping in "${CONFIG_FILES[@]}"; do
    file="${mapping%%:*}"
    TARGET="${mapping##*:}"
    SOURCE="$DOTFILES_DIR/$file"
    
    if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        BACKUP_FILE="${TARGET}.bak.$(date +%s)"
        echo "Warning: $TARGET exists. Backing up..."
        mv "$TARGET" "$BACKUP_FILE"
    fi
    ln -sf "$SOURCE" "$TARGET"
    echo "Symlinked $file"
done

# 6. Setup Neovim (LazyVim)
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Installing LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
else
    echo "Neovim config already exists."
fi

# 7. Setup Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# 8. Setup Local Secrets Skeleton
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo "Creating local secrets template (~/.zshrc.local)..."
    cat > "$HOME/.zshrc.local" << 'EOF'
# ~/.zshrc.local
# This file is NEVER tracked by Git. 
# Put your private API keys, work-specific environment variables, and AWS tokens here.

# export OPENAI_API_KEY="sk-..."
# export AWS_ACCESS_KEY_ID="..."
# export GITHUB_TOKEN="..."
EOF
fi

echo "Installation complete."
