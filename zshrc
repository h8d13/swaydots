# Python settings
export VIRTUAL_ENV_DISABLE_PROMPT=1
venv_prompt() {
  [[ -n "$VIRTUAL_ENV" ]] || return
  local name=${VIRTUAL_ENV:t}
  echo -n "─%F{red}[%F{green}$name%F{red}]%f"
}

# Completion init
autoload -Uz compinit && compinit

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

# Grayed out difference when is suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777'

# Load autosuggestions from ~/.config/zsh/
ZSH_CONFIG_DIR="$HOME/.config/zsh"
plugin_file="$ZSH_CONFIG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"

# Ensure autosuggestions start
(( $+functions[_zsh_autosuggest_start] )) && _zsh_autosuggest_start

# Source substring search
plugin_file="$ZSH_CONFIG_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"

# Search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Correction
setopt CORRECT CORRECT_ALL

# Git VCS info
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' formats '%F{red}─[%F{yellow}git:%F{green}%b%c%u%F{red}]'
zstyle ':vcs_info:git:*' actionformats '%F{red}─[%F{yellow}git:%F{green}%b%F{red}|%a%c%u%F{red}]'
precmd() { vcs_info }

# Prompt
PROMPT='%F{red}┌──[%F{cyan}%D{%H:%M}%F{red}]─[%F{default}%n%F{red}@%F{cyan}%m%F{red}]─[%F{green}%~%F{red}]${vcs_info_msg_0_}$(venv_prompt)
%F{red}└──╼ %F{cyan}$ %f'

# Source aliases and environment
[ -f "$HOME/.config/aliases" ] && . "$HOME/.config/aliases"
[ -f "$HOME/.config/environment" ] && . "$HOME/.config/environment"

# fzf options # ctrl R, ctrl T and alt C
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Note needs to be sourced after defining ^^

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi

# Syntax highlighting (MUST be at the end)
plugin_file="$ZSH_CONFIG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"