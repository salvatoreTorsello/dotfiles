# ZSH main configuration

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v
bindkey '^R' history-incremental-search-backward

# compistall configuration

zstyle :compinstall filename '/home/salvo/.zshrc'

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' gain-privileges 1

# ZSH pure prompt

fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit
promptinit
prompt pure


# Nvim go configuration

if [[ -d "/usr/local/go/bin" ]]; then
        PATH="/usr/local/go/bin:$PATH"
fi
export GO111MODULE=on

# Note: for wsl only, switch to home dir
cd ~

# Aliases

alias ls='ls --color=auto'

if [[ -e $HOME/.cargo/env ]]; then
        . "$HOME/.cargo/env"
fi
