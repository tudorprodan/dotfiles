## Plugins
#
# Plugins are vendored into zsh/plugins/ (gitignored), not tracked as submodules.
# On a new machine, or to update, run:  zsh-plugins-sync
#
# Loading is guarded: a machine that has not synced yet still gets a working
# shell, just without the extras.

ZSH_PLUGIN_DIR=$HOME/.dotfiles/zsh/plugins

# "name url" pairs. Order matters — plugins are sourced in this order, and some
# care about it (e.g. syntax highlighting must come before autosuggestions).
typeset -ga _ZSH_PLUGINS=(
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
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

# Grey ghost text. Bump to fg=244 or similar if it is too dim to read.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# Skip suggestions for very long lines, so pasting a huge command stays snappy.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

## Load

if [[ -d $ZSH_PLUGIN_DIR ]]; then
  () {
    local entry name f
    for entry in $_ZSH_PLUGINS; do
      name=${entry%% *}
      for f in $ZSH_PLUGIN_DIR/$name/$name.{zsh,plugin.zsh}; do
        [[ -r $f ]] && { source $f; break }
      done
    done
  }
else
  print -P "%F{yellow}==>%f zsh plugins not installed, run 'zsh-plugins-sync'"
fi
