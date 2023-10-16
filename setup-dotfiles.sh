#!/bin/bash

# Symlink all dotfiles
for file in $(alias ls="ls"; ls -pA | grep '^\.' | grep -v 'ignore\|backup\|/'); do
  ln -sf ${PWD}/$file ~/$file
done

# Copy zsh config files
[ -d ~/.zsh ] || mkdir ~/.zsh
for file in $(ls .zsh); do
  ln -sf ${PWD}/.zsh/$file ~/.zsh/$file
done

# Set up vim configuration
if [ ! -d "~/.config" ]
then
	mkdir -p ~/.config
fi
ln -sf ${PWD}/nvim ~/.config/nvim

# Set up starship prompt configuration
ln -sf ${PWD}/starship.toml ~/.config/starship.toml
