# ==============================================================================
# FILE: Brewfile
# DESCRIPTION: Declarative dependency graph for Homebrew.
#              Defines all necessary CLI tools (Rust binaries), version managers
#              (fnm, uv), and GUI Casks (Alacritty, Rectangle, OrbStack, Ollama)
#              required to provision the developer environment.
# ==============================================================================

# Taps
tap "homebrew/core"
tap "homebrew/cask"

# Core CLI Tools
brew "eza"             # Modern ls
brew "bat"             # Modern cat
brew "fzf"             # Fuzzy finder
brew "zoxide"          # Smarter cd
brew "ripgrep"         # Fast search
brew "fd"              # Fast find
brew "jq"              # JSON processor
brew "yq"              # YAML processor
brew "gh"              # GitHub CLI
brew "tealdeer"        # Fast tldr (simplified man pages)
brew "jujutsu"         # Next-gen Git-compatible VCS
brew "bottom"          # Modern htop replacement
brew "wget"            # Downloader
brew "neovim"          # Editor
brew "starship"        # Prompt
brew "tmux"            # Multiplexer
brew "defaultbrowser"  # Tool to set default browser
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Version Managers
brew "fnm"             # Fast Node Manager (Rust-based NVM alternative)
brew "uv"              # Extremely fast Python package installer and resolver

# Casks (GUI Applications)
cask "google-chrome"
cask "alacritty"
cask "font-jetbrains-mono-nerd-font"
cask "raycast"         # Spotlight replacement
cask "rectangle"       # Essential window manager (snapping)
cask "orbstack"        # Fast, light Docker Desktop replacement
cask "visual-studio-code"
cask "ollama"          # Local LLM runner
