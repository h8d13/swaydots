#!/bin/sh
# Usage: ./linker.sh <user>       (run as root, e.g. inside chroot)
#        doas ./linker.sh <user>  (live system)
# Explicit $1 wins over DOAS_USER so doas-invoking user (e.g. host user)
# cant leak in when an alpm-style target is intended.
USER="${1:-$DOAS_USER}"

if ! id "$USER" >/dev/null 2>&1; then
    echo "linker.sh: user '$USER' does not exist on this system" && exit 1
fi

if [ ! -d "/home/$USER" ]; then
    echo "linker.sh: /home/$USER missing" && exit 1
fi

PKGS="
    jq bash fd fzf grep diffutils iproute2 bottom
    mandoc man-pages mandoc-apropos less
    zsh zsh-vcs zsh-completions zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search
    mako libnotify
    mpv yt-dlp
    kcalc
    micro
    glow@testing
    nnn
    wl-clipboard
    cliphist@testing
    chromium
    dbus-x11 upower
"
apk add $PKGS

mkdir -p /home/$USER/.config/bash
mkdir -p /home/$USER/.config/zsh
mkdir -p /home/$USER/.config/sway
mkdir -p /home/$USER/.config/foot
mkdir -p /home/$USER/.config/mako
mkdir -p /home/$USER/.config/micro

rm -f /etc/environment
rm -f /etc/issue
rm -f /etc/motd
rm -f /home/$USER/.config/sway/config

ln -s /home/$USER/.swaydots/etc/environment /etc/environment
ln -s /home/$USER/.swaydots/etc/issue /etc/issue
ln -s /home/$USER/.swaydots/etc/motd /etc/motd
ln -s /home/$USER/.swaydots/sway/config /home/$USER/.config/sway/config
ln -s /home/$USER/.swaydots/sway/status.sh /home/$USER/.config/sway/status.sh
ln -s /home/$USER/.swaydots/sway/toggle-colors.sh /home/$USER/.config/sway/toggle-colors.sh

ln -sf /home/$USER/.swaydots/sway/theme-dark.conf /home/$USER/.config/sway/theme.conf
ln -sf /home/$USER/.swaydots/foot/foot-dark.ini /home/$USER/.config/foot/foot.ini
ln -sf /home/$USER/.swaydots/mako/mako-dark.conf /home/$USER/.config/mako/config
ln -s /home/$USER/.swaydots/micro/settings.json /home/$USER/.config/micro/settings.json

ln -s /home/$USER/.swaydots/aliases /home/$USER/.config/aliases
ln -s /home/$USER/.swaydots/profile /home/$USER/.profile
ln -s /home/$USER/.swaydots/ashrc /home/$USER/.ashrc
ln -s /home/$USER/.swaydots/bashrc /home/$USER/.config/bash/bashrc
ln -s /home/$USER/.swaydots/zshrc /home/$USER/.config/zsh/zshrc

# Hand /home/$USER to the user before running k/* (those scripts assume
# non-root: they git clone into $HOME, write rcfiles, and 00_header_checks
# bails on EUID 0). Without the chown the user-side git clones would hit
# root-owned dirs.
chown -R "$USER":"$USER" "/home/$USER"
# we can now safely hand off to plugins k/ dir 
su - "$USER" -c "cd /home/$USER/.swaydots && ./mods"
