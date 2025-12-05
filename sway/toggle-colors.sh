#!/bin/bash
# Toggle between dark and light themes by switching symlinks

SWAY_SOURCE="$HOME/swaydots/sway"
FOOT_SOURCE="$HOME/swaydots/foot"

SWAY_DARK="$SWAY_SOURCE/theme-dark.conf"
SWAY_LIGHT="$SWAY_SOURCE/theme-light.conf"
SWAY_LINK="$HOME/.config/sway/theme.conf"

FOOT_DARK="$FOOT_SOURCE/foot-dark.ini"
FOOT_LIGHT="$FOOT_SOURCE/foot-light.ini"
FOOT_LINK="$HOME/.config/foot/foot.ini"

# Check which theme is currently active
CURRENT=$(readlink "$SWAY_LINK" 2>/dev/null || echo "$SWAY_DARK")

if [[ "$CURRENT" == *"dark"* ]]; then
    ln -sf "$SWAY_LIGHT" "$SWAY_LINK"
    ln -sf "$FOOT_LIGHT" "$FOOT_LINK"
else
    ln -sf "$SWAY_DARK" "$SWAY_LINK"
    ln -sf "$FOOT_DARK" "$FOOT_LINK"
fi

swaymsg reload
