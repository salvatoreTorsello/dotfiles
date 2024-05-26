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

# End of lines for ZSH pure prompt

# set PATH so it includes /usr/local/go/bin if it exists
if [ -d "/usr/local/go/bin" ] ; then
        PATH="/usr/local/go/bin:$PATH"
fi
