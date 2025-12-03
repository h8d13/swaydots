#!/bin/bash

doas rm -f /etc/environment
rm -f ~/.config/sway/config

doas ln -s ~/swaydots/etc/environment /etc/environment
ln -s ~/swaydots/sway/config ~/.config/sway/config
ln -s ~/swaydots/foot/foot.ini ~/.config/foot/foot.ini
ln -s ~/swaydots/.profile ~/.profile
ln -s ~/swaydots/.ashrc ~/.ashrc
