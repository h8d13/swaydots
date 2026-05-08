#!/bin/sh
# meant to run with doas
USER="${DOAS_USER:-$1}"

PKGS="
    git jq bash zsh zsh-vcs fd fzf grep diffutils iproute2 bottom
    mako libnotify
    mandoc man-pages mandoc-apropos less
    mpv yt-dlp
    qcalc
    micro glow
    nnn
    wl-clipboard cliphist
    chromium
    dbus-x11 upower
"
apk add $PKGS

mkdir -p /home/$USER/.config/bash
mkdir -p /home/$USER/.config/zsh
mkdir -p /home/$USER/.config/sway
mkdir -p /home/$USER/.config/foot
mkdir -p /home/$USER/.config/mako

rm -f /etc/environment
rm -f /etc/issue
rm -f /etc/motd
rm -f /home/$USER/.config/sway/config

ln -s /home/$USER/swaydots/etc/environment /etc/environment
ln -s /home/$USER/swaydots/etc/issue /etc/issue
ln -s /home/$USER/swaydots/etc/motd /etc/motd
ln -s /home/$USER/swaydots/sway/config /home/$USER/.config/sway/config
ln -s /home/$USER/swaydots/sway/status.sh /home/$USER/.config/sway/status.sh
ln -s /home/$USER/swaydots/sway/toggle-colors.sh /home/$USER/.config/sway/toggle-colors.sh

ln -sf /home/$USER/swaydots/sway/theme-dark.conf /home/$USER/.config/sway/theme.conf
ln -sf /home/$USER/swaydots/foot/foot-dark.ini /home/$USER/.config/foot/foot.ini
ln -sf /home/$USER/swaydots/mako/mako-dark.conf /home/$USER/.config/mako/config
ln -s /home/$USER/swaydots/micro/settings.json /home/$USER/.config/micro/settings.json

ln -s /home/$USER/swaydots/aliases /home/$USER/.config/aliases
ln -s /home/$USER/swaydots/profile /home/$USER/.profile
ln -s /home/$USER/swaydots/ashrc /home/$USER/.ashrc
ln -s /home/$USER/swaydots/bashrc /home/$USER/.config/bash/bashrc
ln -s /home/$USER/swaydots/zshrc /home/$USER/.config/zsh/zshrc

./mods # now that we have bash = allow bashisms but limit in key scripts like status.sh
