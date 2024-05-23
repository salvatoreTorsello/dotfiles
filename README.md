# dotfiles

## Getting started

This repository collects configuration files and istructions to reproduce a working environment based on Linux OS.
Read about stow at this [link](https://finnala.dev/blog/git-symlinks-and-stow-how-to-manage-your-dotfiles/)

Install the required packages:
```
sudo apt-get install tree git stow zsh neovim
```

## ZSH

Install pure zsh prompt as described on [github-repo](https://github.com/sindresorhus/pure)
```
$ mkdir -p "$HOME/.zsh"
$ git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
```

After that, just delete/rename old ~/.zshrc file and then whitin dotfiles directory run
```
$ git stow zsh
```
