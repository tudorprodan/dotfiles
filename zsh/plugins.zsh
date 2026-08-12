## Plugins
#
# Plugins are git submodules under zsh/plugins/, pinned to a commit that is
# recorded in this repo. Nothing here fetches code: the pin only moves when you
# deliberately update it. See README.md for the clone and update commands.
#
# Loading is guarded, so a clone without submodules still gets a working shell,
# just without the extras.
#
# This file must be sourced after completion.zsh -- see the note there.

ZSH_PLUGIN_DIR=$HOME/.dotfiles/zsh/plugins

# Sourced in this order, which is load-bearing:
#   fzf-tab must come after compinit but before anything that wraps widgets,
#   and the two widget wrappers go last.
# zsh-completions is a submodule too but is deliberately absent here: it only
# adds to $fpath, and completion.zsh does that before compinit.
typeset -ga _ZSH_PLUGIN_LOAD=(
  fzf-tab
  fast-syntax-highlighting
  zsh-autosuggestions
)

## Plugin settings (must be set before the plugin is sourced)

# --- fzf-tab ---
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

# --- zsh-autosuggestions ---
# Grey ghost text. Bump to fg=244 or similar if it is too dim to read.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# Skip suggestions for very long lines, so pasting a huge command stays snappy.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

## Load

() {
  local name f
  local -i loaded=0
  for name in $_ZSH_PLUGIN_LOAD; do
    for f in $ZSH_PLUGIN_DIR/$name/$name.{plugin.zsh,zsh}; do
      [[ -r $f ]] && { source $f; (( loaded++ )); break }
    done
  done
  # An uninitialised submodule leaves an empty directory behind, so check that
  # something actually loaded rather than that the directory exists.
  (( loaded == $#_ZSH_PLUGIN_LOAD )) ||
    print -P "%F{yellow}==>%f zsh plugins missing, run: git -C ~/.dotfiles submodule update --init"
}
