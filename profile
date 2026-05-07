export ENV=$HOME/.ashrc
. $ENV

export ALIASES_FILE=$HOME/.config/aliases
. $ALIASES_FILE

if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session sway
fi
