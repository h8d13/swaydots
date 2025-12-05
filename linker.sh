#!/bin/bash

mkdir -p ~/.config/bash
mkdir -p ~/.config/zsh
mkdir -p ~/.config/sway
mkdir -p ~/.config/foot

doas rm -f /etc/environment
rm -f ~/.config/sway/config

doas ln -s ~/swaydots/etc/environment /etc/environment
ln -s ~/swaydots/sway/config ~/.config/sway/config
ln -s ~/swaydots/sway/status.sh ~/.config/sway/status.sh
ln -s ~/swaydots/sway/toggle-colors.sh ~/.config/sway/toggle-colors.sh

# Theme symlinks (default to dark theme)
ln -sf ~/swaydots/sway/theme-dark.conf ~/.config/sway/theme.conf
ln -sf ~/swaydots/foot/foot-dark.ini ~/.config/foot/foot.ini

ln -s ~/swaydots/aliases ~/config/aliases
ln -s ~/swaydots/profile ~/.profile
ln -s ~/swaydots/ashrc ~/.ashrc
ln -s ~/swaydots/bashrc ~/.config/bash/bashrc
ln -s ~/swaydots/zshrc ~/.config/zsh/zshrc
