## Plugins
#
# Git submodules under zsh/plugins/, pinned to a commit in this repo; nothing
# fetches at startup. See README.md.
#
# Must load after completion.zsh, and in this order: fzf-tab needs compinit
# first, and the widget-wrapping plugins have to come last.

ZSH_PLUGIN_DIR=$HOME/.dotfiles/zsh/plugins

# Submodules are initialised as a set, so one missing file means none are there.
if [[ ! -r $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh ]]; then
  print -P "%F{yellow}==>%f zsh plugins missing, run: git -C ~/.dotfiles submodule update --init"
  return
fi


## fzf-tab -- replaces the completion menu with a fuzzy finder
# ==================================

if command -v eza >/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:(z|j):*' fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
fi
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
# , and . step through completion groups (files vs directories vs options)
zstyle ':fzf-tab:*' switch-group ',' '.'

source $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh


## fast-syntax-highlighting -- colours the command line as you type
# ==================================

# Without this the plugin silently downloads its theme from master on first run,
# outside the commit this submodule is pinned to. The file is already in the repo.
FAST_WORK_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/fast-syntax-highlighting
[[ -d $FAST_WORK_DIR ]] || mkdir -p $FAST_WORK_DIR
[[ -e $FAST_WORK_DIR/secondary_theme.zsh ]] ||
  cp $ZSH_PLUGIN_DIR/fast-syntax-highlighting/share/free_theme.zsh \
     $FAST_WORK_DIR/secondary_theme.zsh

source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Must come after the source above: the plugin loads its theme there, which
# would overwrite anything set earlier. The defaults are colours 2 and 5, both
# too dark to read on black. Directories are a separate key from files.
FAST_HIGHLIGHT_STYLES[path]='fg=183'
FAST_HIGHLIGHT_STYLES[path_pathseparator]='fg=183'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=183,underline'

# Everything that resolves to something runnable.
for _k in command alias builtin function hashed-command precommand suffix-alias; do
  FAST_HIGHLIGHT_STYLES[$_k]='fg=40'
done
unset _k


## zsh-autosuggestions -- grey ghost text
# ==================================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'   # bump to fg=244 if too dim to read
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# 'completion' is what suggests commands you have never run. It forks a zpty per
# suggestion; drop it if typing ever feels laggy.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
