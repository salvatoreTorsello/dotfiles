# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/). 
Each top-level directory is a Stow package whose contents are symlinked into `$HOME`.

## Packages

| Package | Contents |
|---------|----------|
| `nvim` | Neovim config (lazy.nvim, LSP, Telescope, Claude Code, Treesitter) |
| `zsh` | `.zshrc` + zsh-autosuggestions submodule |
| `zellij` | Zellij terminal multiplexer config |
| `i3` | i3 window manager config |
| `scripts` | Shell helpers sourced by `.zshrc` via `~/.tools` |

## Prerequisites

```sh
# Arch / pacman
sudo pacman -S git stow zsh neovim zellij xdotool
```

## Getting started

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive
```

Apply all packages:

```sh
stow nvim zsh zellij i3 scripts
```

Or a single package:

```sh
stow nvim
```

Remove a package:

```sh
stow -D nvim
```

## ZSH

Install the [Pure](https://github.com/sindresorhus/pure) prompt manually (not managed by Stow):

```sh
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
```

Set ZSH as default shell:

```sh
chsh -s $(which zsh)
```
