# swaydots

my dot files for alpine sway high contrast dark theme
no extra deps only built-in ash + bash/zsh (fresh alpine install)

`doas apk add zsh zsh-vcs bash fd fzf grep diffutils iproute2 bottom`

## Cursors

`doas apk add cursors-breeze`

## Notifications

`doas apk add mako`

## Man pages

Also setup less pager coloring. 

`doas apk add mandoc man-pages mandoc-apropos less`

You can then `apk add <something>-doc` and `man <something>`.

## File explorer

`doas apk add thunar adwaita-icon-theme`

## Terminal browser

`doas apk add qutebrowser upower`

## Terminal media

`doas apk add mpv yt-dlp`

Audio: `play darude sandstorm`
Video: `playv never gonna give you up`

Binds are set to work with alsa which I've found easy to use.

## Terminal calc 

`doas apk add qcalc`

My laptop had a media key for this

## Terminal editor

`doas apk add micro`

Micro settings for SSH copy/paste and doas elevation.

## Terminal markdown

`doas apk add glow`

Or the same locally: `glow https://url-to-raw-md-file`

----

styles made for OLED screens, long coding sessions and least amount of flashy colors possible

using a linker to be able to dynamically edit git repo which updates the actual system in real-time. 
this follows runit patterns where all symlinks are from a single location being this repo.

<img width="1920" height="1080" alt="20251203_16h38m29s_grim" src="https://github.com/user-attachments/assets/2195b7d6-ec06-4a02-a97f-fb3d1c5411d6" />

<img width="1920" height="1080" alt="20251204_05h01m58s_grim" src="https://github.com/user-attachments/assets/df108675-1ffa-4c39-b783-c5ddaa83308b" />

----

## Functions

WiFi connect (prompts for password if unknown):
```bash
cwifi "network-name"
```

Switch back to ethernet:
```bash
ccable
```

Start dbus:
```bash
backbus
```

`doas apk add dbus dbus-x11` 
Then add dbus to boot level.

This provides userspace tools such as notifications, upower, ...

Can test with **mod+U** which will return `5 updates available`

## Shortcuts Cheatsheet:

> In order of how frequently I use

```
1. **Mod+Shift+Enter** 		# Open zsh
2. **Mod+Shift+Q** 			# Close something focused
3. **Ctrl+Shift+R**			# Search inside foot term session
---> Ctrl N or P next/previous matches
4. **Ctrl+F**<term> ENTER   # Inside micro editor to search
---> Ctrl N or P next/previous matches
5. **Mod+X** 				# Switch to a workspace
6. **Mod+Shift+$X**			# Move something to X workspace
7. **Mod+Shift+Space**      # Make a window floaty F9 works too
8. **Mod+M** 				# Opens bottom monitor
9. **Mod+T**                # Toggle between dark/light theme
10. **Mod+Shift+C**         # Reload sway config for small changes
```
