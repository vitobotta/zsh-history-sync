fzf-history-widget() {
  setopt extendedglob
  fc -R
  LBUFFER=$(fc -l -n -1 0 | awk '!x[$0]++' | fzf --height=40% --border --prompt="Select command: ")
  zle redisplay
}

__reload_history() {
  fc -R
}

__sync_history() {
  $ZSH_HISTORY_SYNC_SCRIPT_PATH $ZSH_HISTORY_SYNC_FILE_PATH
}

add-zsh-hook preexec __reload_history
add-zsh-hook precmd __sync_history

zle -N fzf-history-widget
bindkey '^r' fzf-history-widget
bindkey '^[[A' fzf-history-widget
bindkey '^[OA' fzf-history-widget

alias synchistory="$ZSH_HISTORY_SYNC_SCRIPT_PATH $ZSH_HISTORY_SYNC_FILE_PATH"
