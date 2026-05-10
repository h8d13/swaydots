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

# we do not use setup-desktop because that pulls in elogind daemon
# swayidle pulls in libelogind the .so at 569KB, but NOT the elogind daemon

SWAY="
    sway swaybg swaylockd foot grim wl-clipboard wmenu swayidle
    xwayland font-dejavu i3status brightnessctl util-linux-login
"

# dotfiles deps
XTRA_PKGS="
    jq bash fd fzf grep diffutils iproute2 bottom
    mandoc man-pages mandoc-apropos less
    zsh zsh-vcs zsh-completions zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search
    mako libnotify
    mpv yt-dlp
    kcalc
    micro
    nnn
    cliphist@testing
    glow@testing
    chromium
    dbus-x11
"
    #vscodium@testing
    #upower

apk add $SWAY $XTRA_PKGS

# dirs
mkdir -p /home/$USER/.config/bash
mkdir -p /home/$USER/.config/zsh
mkdir -p /home/$USER/.config/sway
mkdir -p /home/$USER/.config/foot
mkdir -p /home/$USER/.config/mako
mkdir -p /home/$USER/.config/micro
mkdir -p /home/$USER/.config/swayidle
mkdir -p /home/$USER/.local/bin

# system
rm -f /etc/environment
rm -f /etc/issue
rm -f /etc/motd
rm -f /home/$USER/.config/sway/config

ln -s /home/$USER/.swaydots/etc/environment /etc/environment
ln -s /home/$USER/.swaydots/etc/issue /etc/issue
ln -s /home/$USER/.swaydots/etc/motd /etc/motd

# shells
ln -s /home/$USER/.swaydots/aliases /home/$USER/.config/aliases
ln -s /home/$USER/.swaydots/environment /home/$USER/.config/environment
ln -s /home/$USER/.swaydots/profile /home/$USER/.profile
ln -s /home/$USER/.swaydots/ashrc /home/$USER/.ashrc
ln -s /home/$USER/.swaydots/bashrc /home/$USER/.config/bash/bashrc
ln -s /home/$USER/.swaydots/zshrc /home/$USER/.config/zsh/zshrc
# tiny stubs at $HOME that source the .config/<shell>/<rc> split.
ln -s /home/$USER/.swaydots/home_bashrc /home/$USER/.bashrc
ln -s /home/$USER/.swaydots/home_zshrc /home/$USER/.zshrc

# user bin
ln -s /home/$USER/.swaydots/bin/hello /home/$USER/.local/bin/hello

# sway or related
ln -s /home/$USER/.swaydots/sway/config /home/$USER/.config/sway/config
ln -s /home/$USER/.swaydots/sway/status.sh /home/$USER/.config/sway/status.sh
ln -s /home/$USER/.swaydots/sway/toggle-colors.sh /home/$USER/.config/sway/toggle-colors.sh
ln -s /home/$USER/.swaydots/swayidle/config /home/$USER/.config/swayidle/config

ln -sf /home/$USER/.swaydots/sway/theme-dark.conf /home/$USER/.config/sway/theme.conf
ln -sf /home/$USER/.swaydots/foot/foot-dark.ini /home/$USER/.config/foot/foot.ini
ln -sf /home/$USER/.swaydots/mako/mako-dark.conf /home/$USER/.config/mako/config
ln -s /home/$USER/.swaydots/micro/settings.json /home/$USER/.config/micro/settings.json

# restore perms
chown -R "$USER":"$USER" "/home/$USER"