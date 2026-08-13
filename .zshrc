_ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

TIMEFMT="%J  [%U user] [%S system] [%P cpu] [%*E total]"

source $HOME/.dotfiles/zsh/prompt.zsh
source $HOME/.dotfiles/zsh/termsupport.zsh
source $HOME/.dotfiles/zsh/options.zsh
source $HOME/.dotfiles/zsh/history.zsh
source $HOME/.dotfiles/zsh/key-bindings.zsh

[[ -s $HOME/.shell_init.sh ]] && source $HOME/.shell_init.sh


LSCOLORS="exfxcxdxbxegedabagacad"

# less colors for man pages moved to zsh/tools.zsh, next to the bat setup

# Change the default for this, default is underline
# ZSH_HIGHLIGHT_STYLES[path]='fg=blue'

alias ls='ls --color=tty'
alias l='ls -lh'
alias ll='ls -alh'
alias w="w -f"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"
alias du="du -sh"
alias vact="source .venv/bin/activate"
alias apt-get="sudo apt-get"
alias apt="sudo apt"
alias psgrep="ps aux | grep -i"
alias grepi="grep -i"
alias open="xdg-open"
alias fd="fdfind"

# Completion, then external tools, then plugins -- order matters, see
# the comments at the top of completion.zsh and plugins.zsh
source $HOME/.dotfiles/zsh/completion.zsh
source $HOME/.dotfiles/zsh/tools.zsh
source $HOME/.dotfiles/zsh/plugins.zsh

# Command suggestion
[[ -r /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

# Time last command
function timecmd_preexec() {
  timer=${timer:-$SECONDS}
}
function timecmd_precmd() {
  if [ $timer ]; then
    timer_res=$(($SECONDS - $timer))
    if [[ $timer_res -gt 5 ]]; then
        export RPROMPT="${timer_res}s"
    else
        unset RPROMPT
    fi
    unset timer
  fi
}
preexec_functions+=(timecmd_preexec)
precmd_functions+=(timecmd_precmd)

function title_precmd() {
    emulate -L zsh
}

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# .local
[ -f ~/.local/bin/env ] && source ~/.local/bin/env

# Ctrl + left/right
# bindkey ';5C' emacs-forward-word
# bindkey ';5D' emacs-backward-word
# bindkey '\eOC' emacs-forward-word
# bindkey '\eOD' emacs-backward-word
