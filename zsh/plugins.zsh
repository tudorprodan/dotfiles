## Plugins
#
# Plugins are vendored into zsh/plugins/ (gitignored), not tracked as submodules.
# On a new machine, or to update, run:  zsh-plugins-sync
#
# Loading is guarded: a machine that has not synced yet still gets a working
# shell, just without the extras.
#
# This file must be sourced after completion.zsh -- see the note there.

ZSH_PLUGIN_DIR=$HOME/.dotfiles/zsh/plugins

# "name url" pairs. Everything here gets cloned by zsh-plugins-sync.
typeset -ga _ZSH_PLUGINS=(
  "zsh-completions https://github.com/zsh-users/zsh-completions.git"
  "fzf-tab https://github.com/Aloxaf/fzf-tab.git"
  "fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
)

# Sourced in this order, which is load-bearing:
#   fzf-tab must come after compinit but before anything that wraps widgets,
#   and the two widget wrappers go last.
# zsh-completions is deliberately absent: it only adds to $fpath, and
# completion.zsh does that before compinit.
typeset -ga _ZSH_PLUGIN_LOAD=(
  fzf-tab
  fast-syntax-highlighting
  zsh-autosuggestions
)

# Install anything missing, fast-forward anything already there.
function zsh-plugins-sync {
  emulate -L zsh
  local entry name url dir
  mkdir -p $ZSH_PLUGIN_DIR
  for entry in $_ZSH_PLUGINS; do
    name=${entry%% *}
    url=${entry#* }
    dir=$ZSH_PLUGIN_DIR/$name
    if [[ -d $dir/.git ]]; then
      print -P "%F{blue}==>%f updating $name"
      git -C $dir pull --quiet --ff-only || print -P "%F{red}==>%f $name: pull failed"
    else
      print -P "%F{green}==>%f installing $name"
      git clone --depth 1 --quiet $url $dir || print -P "%F{red}==>%f $name: clone failed"
    fi
  done
  print -P "%F{green}==>%f done, run 'exec zsh' to reload"
}

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

if [[ -d $ZSH_PLUGIN_DIR ]]; then
  () {
    local name f
    for name in $_ZSH_PLUGIN_LOAD; do
      for f in $ZSH_PLUGIN_DIR/$name/$name.{plugin.zsh,zsh}; do
        [[ -r $f ]] && { source $f; break }
      done
    done
  }
else
  print -P "%F{yellow}==>%f zsh plugins not installed, run 'zsh-plugins-sync'"
fi
