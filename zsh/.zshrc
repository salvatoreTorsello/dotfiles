# Lines configured by zsh-newuser-install

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v

# End of lines configured by zsh-newuser-install



# The following lines were added by compinstall

zstyle :compinstall filename '/home/salvo/.zshrc'

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

# End of lines added by compinstall

# ZSH pure prompt

fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit
promptinit
prompt pure
xdotool key ctrl+l

# End of lines for ZSH pure prompt
