_ZSH_RIGHTARROW=$'\ue0b0'
_ZSH_NEWLINE=$'\n'
_ZSH_AUTOJUMP_PATH=/usr/share/autojump/autojump.sh
_ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

PROMPT="${_ZSH_NEWLINE}%F{black}%K{green} %n %F{green}%K{blue}${_ZSH_RIGHTARROW}%F{white}%K{blue} %1~ %F{blue}%k%(?..%K{red}${_ZSH_RIGHTARROW}%F{black}%K{red} ✖ %? %F{red}%k)${_ZSH_RIGHTARROW} %f%k"

TIMEFMT="%J  [%U user] [%S system] [%P cpu] [%*E total]"

source $HOME/.dotfiles/zsh/submodules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.dotfiles/zsh/submodules/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.dotfiles/zsh/submodules/history-search-multi-word/history-search-multi-word.plugin.zsh
source $HOME/.dotfiles/zsh/termsupport.zsh
source $HOME/.dotfiles/zsh/history.zsh
source $HOME/.dotfiles/zsh/key-bindings.zsh

# KCG build init
[[ -S $HOME/.build_init.sh ]] && source $HOME/.build_init.sh

TERM='xterm-256color'  # Make sure the right thing is sent
NO_AT_BRIDGE=1  # Disable gnome accessibility to stop the warnings
LSCOLORS="exfxcxdxbxegedabagacad"
EDITOR=vim
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
ZSH_HIGHLIGHT_STYLES[path]='fg=blue'

alias ls='ls --color=tty'
alias l='ls -alh'
alias ll='ls -alh'
alias w="w -f"
alias vi="vim"
alias du="du -sh"
alias vact="source .venv/bin/activate"
alias make="make -j24"
alias apt-get="sudo apt-get"
alias apt="sudo apt"
alias psgrep="ps aux | grep -i"
alias grepi="grep -i"
alias open="xdg-open"


# Completion
[[ -s $_ZSH_AUTOJUMP_PATH ]] && source $_ZSH_AUTOJUMP_PATH
autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
setopt menu_complete

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

# Ctrl + left/right
bindkey ';5C' emacs-forward-word
bindkey ';5D' emacs-backward-word
