# ==============================================================================
# FILE: .zshrc
# DESCRIPTION: Interactive Zsh configuration loaded on every terminal session.
#              Configures history ergonomics, loads Starship prompt, integrates
#              Rust CLI tools (zoxide, eza, fzf), and sets up
#              aliases for git, tmux, and local AI (Gemma/Aider).
# ==============================================================================

# 1. Deduplicate PATH entries automatically
typeset -U path PATH

# 2. Load shared profile environment variables and PATH
if [ -f ~/.profile ]; then
    source ~/.profile
fi

# 3. Zsh Options for Ergonomics & History
# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Ergonomics
setopt AUTO_CD                   # If a command is a directory name, cd into it.
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell.

# 4. Advanced Completions
autoload -Uz compinit
compinit
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Colored completion menus
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Interactive menu selection
zstyle ':completion:*' menu select

# 5. Key Bindings (Prefix Search)
# Bind UP/DOWN arrows to search history based on what's already typed
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Support for standard Ctrl+Left/Right word jumping
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# 6. Interactive Shell Setup & Theme (Starship)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# 7. Next-Gen CLI Tool Integrations (fzf, zoxide, eza, bat)
# fzf integration (Fuzzy finder)
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

# zoxide integration (Smarter cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# eza integration (Modern ls replacement)
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --color=always --group-directories-first --icons"
    alias ll="eza -al --color=always --group-directories-first --icons"
    alias la="eza -a --color=always --group-directories-first --icons"
    alias tree="eza --tree --color=always --icons"
else
    # Fallback to standard color ls
    export CLICOLOR=1
    alias ls="ls -G"
    alias ll="ls -alG"
    alias la="ls -aG"
fi

# bat integration (Modern cat replacement)
if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi


# 9. Shell Limits
ulimit -n 4096

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
alias reload="source ~/.zshrc && echo 'Zsh config reloaded!'"

# Local AI
alias gemma="ollama run gemma4"
alias gemma-vision="ollama run gemma4:12b"
alias gemma-pro="ollama run gemma4:26b"

# Agentic Coding
alias aider-local="aider --model ollama/gemma4:26b"

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

# 11. Custom Completions & Integrations
# Bun completions
if [ -s "$BUN_INSTALL/_bun" ]; then
    source "$BUN_INSTALL/_bun"
fi

# Google Cloud SDK integration
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
    source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# 12. Plugins (Must be at the absolute bottom)
HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}
if [ ! -d "$HOMEBREW_PREFIX" ] && [ -d "/usr/local" ]; then HOMEBREW_PREFIX="/usr/local"; fi
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# 13. Node Version Management (fnm)
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd)"
fi

# 14. Local Secrets (Never commit this file to Git)
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
