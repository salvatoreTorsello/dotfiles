# Oh-My-Zsh configuration
export OHMYZSH="$HOME/dotfiles/zsh/ohmyzsh"

# Theme - using minimal since you prefer clean setup
OHMYZSH_THEME="robbyrussell"

# Plugins - enable one at a time as requested
plugins=(zsh-autosuggestions)

# Initialize Oh-My-Zsh
source $OHMYZSH/oh-my-zsh.sh

# Your custom settings (preserved from original)
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v
bindkey '^R' history-incremental-search-backward

# Completion settings (Oh-My-Zsh handles most, but keep your extras)
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' gain-privileges 1

# Pure prompt
fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit
promptinit
prompt pure

# Go configuration
if [[ -d "/usr/local/go/bin" ]]; then
    PATH="/usr/local/go/bin:$PATH"
fi
export GO111MODULE=on

# Start in home directory (WSL note)
cd ~

# Aliases
alias ls='ls --color=auto'

# Cargo environment
if [[ -e $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

# Brew path
if [[ -d "/home/linuxbrew/.linuxbrew/bin/" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# zsh-autosuggestions grey color configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
