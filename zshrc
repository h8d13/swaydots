# Python settings
export VIRTUAL_ENV_DISABLE_PROMPT=1
venv_prompt() {
  [[ -n "$VIRTUAL_ENV" ]] || return
  local name=${VIRTUAL_ENV:t}
  echo -n "─%F{red}[%F{green}$name%F{red}]%f"
}
# auto cd if type dir 
setopt AUTO_CD
# Completion init
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' menu select
# History
HISTSIZE=10000				# Max entires in session
SAVEHIST=10000				# Max entries in file
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY		# Share across sessions
setopt HIST_IGNORE_DUPS     # Don't record duplicates
setopt HIST_FIND_NO_DUPS    # Don't show duplicates when searching
setopt HIST_VERIFY 			# Show command after history expansion before running
# Grayed out difference when is suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777'
# Load autosuggestions from ~/.config/zsh/
ZSH_CONFIG_DIR="$HOME/.config/zsh"
plugin_file="$ZSH_CONFIG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"
# Ensure autosuggestions start
(( $+functions[_zsh_autosuggest_start] )) && _zsh_autosuggest_start
# Correction just for commands not for files/args
setopt CORRECT #CORRECT_ALL
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
# create a zkbd compatible hash
typeset -g -A key
# begin/end of buffer
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
# insert mode
key[Insert]="${terminfo[kich1]}"
# reverse backspace
key[Delete]="${terminfo[kdch1]}"
# first / last commands
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
# reverse completion menu
key[Shift-Tab]="${terminfo[kcbt]}"
# support for Home, End, Delete, PageUp/PageDown, Insert, and Shift-Tab 
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
# Finally, make sure the terminal is in application mode
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
# other kbinds alt +  h for help of current command or esc + h
# fzf options
export FZF_DEFAULT_OPTS='--height 50%'
# Default command for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
# Ctrl-T: Find files
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow'
# Disable Alt-C and set it to move to folders 
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow'
# Ctrl-G go to folder
fzf-cd-widget() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf +m) && cd "$dir"
  zle reset-prompt
}
zle -N fzf-cd-widget
bindkey '^G' fzf-cd-widget
# Note needs to be sourced after defining ^^
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi
# Source substring search
plugin_file="$ZSH_CONFIG_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"
# Search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# move full words (ctrl modififer)
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
# alt-enter mutli-line
bindkey '^[^M' self-insert-unmeta  
# cd - alternative alt + left but remember stacks
# Make cd push to directory stack automatically
# Make cd push to directory stack automatically
setopt AUTO_PUSHD           # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print stack after pushd/popd
# alt + left remember stack
cdUndoKey() {
  popd > /dev/null 2>&1
  zle reset-prompt
}
zle -N cdUndoKey
bindkey '^[[1;3D' cdUndoKey
# dot ration
# Smart dot expansion: cd ..../dir → cd ../../../dir
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
# Syntax highlighting (MUST be at the end)
plugin_file="$ZSH_CONFIG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$plugin_file" ] && . "$plugin_file"
# find new executable completions
zstyle ':completion:*' rehash true
# global zsh alias
alias -g L='| less'
alias -g G='| grep --color=auto'
# sometimes 
alias -g T='| tail'
alias -g H='| head'
alias -g C='| wc -l'
# null/err
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'
