# ==============================================================================
# FILE: .bashrc
# DESCRIPTION: Interactive Bash configuration loaded on every terminal session.
#              Provides a fallback environment identical to .zshrc, integrating
#              Starship, Rust CLI tools, and aliases for systems where
#              Zsh is unavailable or Bash is explicitly requested.
# ==============================================================================

# 1. Interactive Shell Setup & Theme (Starship)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# 2. Shell Limits
ulimit -n 4096

# 3. Next-Gen CLI Tool Integrations
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    alias cd="z"
fi

if command -v eza >/dev/null 2>&1; then
    alias ls="eza --color=always --group-directories-first --icons"
    alias ll="eza -al --color=always --group-directories-first --icons"
    alias la="eza -a --color=always --group-directories-first --icons"
    alias tree="eza --tree --color=always --icons"
else
    export CLICOLOR=1
    alias ls="ls -G"
    alias ll="ls -alG"
    alias la="ls -aG"
fi

if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi

# 4. Aliases (Unix as an IDE)
# Editor
alias v="nvim"
alias vim="nvim"
alias vi="nvim"

# Directory Traversal
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias md="mkdir -p"

# Git (Braintree style)
alias g="git"
alias gst="git status -s"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias ga="git add"
alias gap="git add -p"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias gds="git diff --staged"
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Tmux
alias ta="tmux attach -t"
alias tn="tmux new-session -s"
alias tl="tmux list-sessions"
alias kx="tmux attach -t workspace || tmux new-session -s workspace"

# FZF & Unix IDE Integrations
alias vf="nvim \"\$(fzf --preview 'bat --style=numbers --color=always {}')\"" # Find file and open in neovim (safe for spaces)
alias sf="fzf --preview 'bat --style=numbers --color=always {}'"          # Simply search file with preview
alias rf="rg --color=always"

# Safety & System
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias reload="source ~/.bashrc && echo 'Bash config reloaded!'"

# Local AI
alias gemma="ollama run gemma4"
alias gemma-vision="ollama run gemma4:12b"
alias gemma-pro="ollama run gemma4:26b"

# Agentic Coding
alias aider-local="aider --model ollama/gemma4:26b"

# System Maintenance (The "One Workflow" Updater)
alias sys-update="echo '🍺 Updating Homebrew...' && brew bundle --file=$HOME/dotfiles/Brewfile && brew upgrade && echo '⚡ Updating Python Tools (Aider)...' && uv tool upgrade --all && echo '🚀 Updating Antigravity...' && agy update"

# Shell Pipelining (e.g., cat error.log | ask "why did this crash?")
ask() {
    local prompt="$1"
    if [ -t 0 ]; then
        ollama run gemma4 "$prompt"
    else
        local input
        input=$(cat)
        ollama run gemma4 "$prompt\n\nContext:\n$input"
    fi
}

# 5. Completions & Integrations
if [ -f "$HOME/Downloads/google-cloud-sdk/path.bash.inc" ]; then
    source "$HOME/Downloads/google-cloud-sdk/path.bash.inc"
fi
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.bash.inc" ]; then
    source "$HOME/Downloads/google-cloud-sdk/completion.bash.inc"
fi
