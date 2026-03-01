# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme - Powerlevel10k for beautiful prompt
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins for autocompletion and enhancement
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    docker
    kubectl
    npm
    node
    python
    brew
    macos
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Autocompletion settings
autoload -U compinit && compinit

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Claude Code aliases
alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --reset'

# Development aliases
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'

# Tmux aliases
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Node.js (if using nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
