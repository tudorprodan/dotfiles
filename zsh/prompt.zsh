## Prompt

_ZSH_RIGHTARROW=$'\ue0b0'
# _ZSH_RIGHTARROW=$''
_ZSH_NEWLINE=$'\n'

## Abbreviated working directory
#
# Fish shortens each leading path component to its first letter, so a deep path
# still shows where you are: /home/tudor/.dotfiles/zsh/plugins -> ~/.d/zsh/plugins
# zsh has no built-in for this, so compute it on cd and use the result in PROMPT.

# How many trailing components to leave in full, and the length a path has to
# exceed before it is shortened at all. Short paths stay fully readable.
_PROMPT_PWD_KEEP=2
_PROMPT_PWD_MAXLEN=40

function _prompt_short_pwd {
  emulate -L zsh
  local p=${PWD/#$HOME/\~}
  local -a parts=("${(@s:/:)p}")
  local -i i last=$(( $#parts - _PROMPT_PWD_KEEP ))
  if (( $#p > _PROMPT_PWD_MAXLEN )); then
    for (( i = 1; i <= last; i++ )); do
      case $parts[i] in
        "")  ;;                            # leading empty field of an absolute path
        .*)  parts[i]=${parts[i][1,2]} ;;  # keep the dot: .config -> .c
        *)   parts[i]=${parts[i][1]} ;;
      esac
    done
  fi
  # % has to be doubled. The prompt rescans substituted text for escapes, so a
  # directory named 100%done would otherwise expand %d into the whole path.
  _PROMPT_PWD=${${(j:/:)parts}//\%/%%}
}

chpwd_functions+=(_prompt_short_pwd)
_prompt_short_pwd   # and once for the directory the shell starts in

# prompt_subst is what lets ${_PROMPT_PWD} be re-read on every prompt
setopt prompt_subst

PROMPT="${_ZSH_NEWLINE}%F{black}%K{green} %n@%m %F{green}%K{blue}${_ZSH_RIGHTARROW}%F{white}%K{blue} \${_PROMPT_PWD} %F{blue}%k%(?..%K{red}${_ZSH_RIGHTARROW}%F{black}%K{red} ✖ %? %F{red}%k)${_ZSH_RIGHTARROW} %f%k"
