## Plugins
#
# Plugins are git submodules under zsh/plugins/, pinned to a commit recorded in
# this repo. Nothing here fetches code: the pin only moves when you deliberately
# update it. See README.md for the clone and update commands.
#
# This file must be sourced after completion.zsh -- see the note there.
#
# The order of the blocks below matters: fzf-tab has to load after compinit but
# before anything that wraps zle widgets, so the two wrappers come last.
#
# zsh-completions is a submodule too, but is not sourced here. It only adds to
# $fpath, which completion.zsh does before compinit.

ZSH_PLUGIN_DIR=$HOME/.dotfiles/zsh/plugins

# Submodules are initialised as a set, so one missing file means none are there.
if [[ ! -r $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh ]]; then
  print -P "%F{yellow}==>%f zsh plugins missing, run: git -C ~/.dotfiles submodule update --init"
  return
fi


## fzf-tab -- replaces the completion menu with a fuzzy finder
# ==================================

# Preview the directory you are about to cd into
if command -v eza >/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:(z|j):*' fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
fi
# Show the value of a variable you are completing
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
# Accept with tab as well as enter, and keep the popup compact
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
# , and . step through completion groups (files vs directories vs options)
zstyle ':fzf-tab:*' switch-group ',' '.'

source $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh


## fast-syntax-highlighting -- colours the command line as you type
# ==================================

# On first run the plugin downloads share/free_theme.zsh from its own master
# branch, silently, and sources the result later. That pulls code from outside
# the commit this submodule is pinned to. The file it wants is already in the
# repo, so put it in place ourselves and the download never fires.
#
# FAST_WORK_DIR is set explicitly because the plugin's own default falls back to
# ~/.cache/fsh whenever the directory is not writable, which includes the case
# where it does not exist yet.
FAST_WORK_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/fast-syntax-highlighting
[[ -d $FAST_WORK_DIR ]] || mkdir -p $FAST_WORK_DIR
[[ -e $FAST_WORK_DIR/secondary_theme.zsh ]] ||
  cp $ZSH_PLUGIN_DIR/fast-syntax-highlighting/share/free_theme.zsh \
     $FAST_WORK_DIR/secondary_theme.zsh

source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh


## zsh-autosuggestions -- grey ghost text from history
# ==================================

# Bump to fg=244 or similar if the grey is too dim to read.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# Skip suggestions for very long lines, so pasting a huge command stays snappy.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Suggest from history, then from completions -- the second half is what makes
# fish feel like it knows commands you have never run. It forks a zpty per
# suggestion, so drop 'completion' if typing ever feels laggy.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
