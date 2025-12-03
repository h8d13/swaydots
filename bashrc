# === Custom Bash Prompt Blue ===
export PS1='\[\033[1;34m\]┌──[\[\033[0;36m\]\A\[\033[1;34m\]]─[\[\033[0m\]\u\[\033[1;34m\]@\[\033[0;36m\]\h\[\033[1;34m\]]─[\[\033[0;32m\]\w\[\033[1;34m\]]\n\[\033[1;34m\]└──╼ \[\033[0;36m\]$ \[\033[0m\]'

[ -f "$HOME/.config/aliases" ] && . "$HOME/.config/aliases"
[ -f "$HOME/.config/environment" ] && . "$HOME/.config/environment"

plugin_file="/usr/share/bash-completion/bash_completion"
[ -f "$plugin_file" ] && . "$plugin_file"
