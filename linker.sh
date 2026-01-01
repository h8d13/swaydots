#!/bin/bash
mkdir -p ~/.config/bash
mkdir -p ~/.config/zsh
mkdir -p ~/.config/sway
mkdir -p ~/.config/foot
mkdir -p ~/.config/mako

doas rm -f /etc/environment
rm -f ~/.config/sway/config

doas ln -s ~/swaydots/etc/environment /etc/environment
ln -s ~/swaydots/sway/config ~/.config/sway/config
ln -s ~/swaydots/sway/status.sh ~/.config/sway/status.sh
ln -s ~/swaydots/sway/toggle-colors.sh ~/.config/sway/toggle-colors.sh

ln -sf ~/swaydots/sway/theme-dark.conf ~/.config/sway/theme.conf
ln -sf ~/swaydots/foot/foot-dark.ini ~/.config/foot/foot.ini
ln -sf ~/swaydots/mako/mako-dark.conf ~/.config/mako/config
ln -s ~/swaydots/micro/settings.json ~/.config/micro/settings.json

ln -s ~/swaydots/aliases ~/.config/aliases
ln -s ~/swaydots/profile ~/.profile
ln -s ~/swaydots/ashrc ~/.ashrc
ln -s ~/swaydots/bashrc ~/.config/bash/bashrc
ln -s ~/swaydots/zshrc ~/.config/zsh/zshrc

#./mods
