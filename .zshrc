_ZSH_RIGHTARROW=$'\ue0b0'
# _ZSH_RIGHTARROW=$''
_ZSH_NEWLINE=$'\n'
_ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

PROMPT="${_ZSH_NEWLINE}%F{black}%K{green} %n@%m %F{green}%K{blue}${_ZSH_RIGHTARROW}%F{white}%K{blue} %1~ %F{blue}%k%(?..%K{red}${_ZSH_RIGHTARROW}%F{black}%K{red} ✖ %? %F{red}%k)${_ZSH_RIGHTARROW} %f%k"

TIMEFMT="%J  [%U user] [%S system] [%P cpu] [%*E total]"

source $HOME/.dotfiles/zsh/termsupport.zsh
source $HOME/.dotfiles/zsh/history.zsh
source $HOME/.dotfiles/zsh/key-bindings.zsh
# source $HOME/.dotfiles/zsh/submodules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $HOME/.dotfiles/zsh/submodules/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $HOME/.dotfiles/zsh/submodules/history-search-multi-word/history-search-multi-word.plugin.zsh

[[ -s $HOME/.shell_init.sh ]] && source $HOME/.shell_init.sh


LSCOLORS="exfxcxdxbxegedabagacad"
HISTSIZE=100000

# Customize less colors
LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
LESS_TERMCAP_me=$(tput sgr0)
LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
LESS_TERMCAP_se=$(tput rmso; tput sgr0)
LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
LESS_TERMCAP_mr=$(tput rev)
LESS_TERMCAP_mh=$(tput dim)
LESS_TERMCAP_ZN=$(tput ssubm)
LESS_TERMCAP_ZV=$(tput rsubm)
LESS_TERMCAP_ZO=$(tput ssupm)
LESS_TERMCAP_ZW=$(tput rsupm)

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

# Autojump
_ZSH_AUTOJUMP_PATH=/usr/share/autojump/autojump.zsh
[[ -s $_ZSH_AUTOJUMP_PATH ]] && source $_ZSH_AUTOJUMP_PATH
autoload -U compinit && compinit -u

# Completion
zstyle ':completion:*' menu select
setopt auto_menu

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
