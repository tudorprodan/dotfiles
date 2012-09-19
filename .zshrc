# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
fpath=($fpath /usr/local/share/zsh/site-functions)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="powerline"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(django brew git osx)

source $ZSH/oh-my-zsh.sh

unsetopt correct_all

# Customize to your needs...
alias ll='ls -alhG'
alias w="w -f"
alias vi="vim"
alias du="du -h"

#export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/MacGPG2/bin"
export LSCOLORS="exfxcxdxbxegedabagacad"
export EDITOR=vim

#setopt NoMenuComplete

#PROMPT='%{$fg[red]%} ➥ %{$fg_bold[green]%}%p %{$fg[green]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}# %{$reset_color%}'


#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


POWERLINE_COLOR_BG_GRAY=$BG[240]
POWERLINE_COLOR_BG_LIGHT_GRAY=$BG[240]
POWERLINE_COLOR_BG_WHITE=$BG[255]

POWERLINE_COLOR_FG_GRAY=$FG[240]
POWERLINE_COLOR_FG_LIGHT_GRAY=$FG[240]
POWERLINE_COLOR_FG_WHITE=$FG[255]

GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]

ZSH_THEME_GIT_PROMPT_PREFIX=" \u2b60 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"



#PROMPT='
#'%{$bg[green]%}%{$fg[black]%}' '%n' '%{$reset_color%}%{$fg[green]%}%{$bg[blue]%}$'\u2b80'%{$reset_color%}%{$fg[white]%}%{$bg[blue]%}' '%1~$'$(git_prompt_info) '%{$reset_color%}%{$fg[blue]%}$'\u2b80%{$reset_color%} '
#RPROMPT=%{$POWERLINE_COLOR_FG_WHITE%}$' \u2b82%{$reset_color%}%{$POWERLINE_COLOR_BG_WHITE%} %{$POWERLINE_COLOR_FG_GRAY%}%D{%X}%  \u2b82%{$POWERLINE_COLOR_BG_GRAY%}%{$POWERLINE_COLOR_FG_WHITE%} %D{%Y-%m-%d}%f %{$reset_color%}'

#PROMPT='
#'%{$bg[green]%}%{$fg[black]%}' '%n' '%{$reset_color%}%{$fg[green]%}%{$bg[white]%}$'\u2b80'%{$reset_color%}%{$fg[grey]%}%{$bg[white]%}' '%1~$'$(git_prompt_info) '%{$reset_color%}%{$fg[white]%}$'\u2b80%{$reset_color%} '

PROMPT='
'%{$bg[green]%}%{$fg[black]%}' '%n' '%{$reset_color%}%{$fg[green]%}%{$bg[blue]%}$'\u2b80'%{$reset_color%}%{$fg[white]%}%{$bg[blue]%}' '%1~$'$(git_prompt_info) '%{$reset_color%}%{$fg[blue]%}%(?..%{$bg[red]%}$'\u2b80'%{$fg[black]%}' ✖ %? '%{$reset_color%}%{$fg[red]%})$'\u2b80'%{$reset_color%}' '
