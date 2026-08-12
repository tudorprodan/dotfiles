## Completion
#
# Load order matters, and this file has to come before plugins.zsh:
#   1. extra completion dirs go into $fpath   (here)
#   2. compinit                               (here)
#   3. fzf-tab                                (plugins.zsh)
#   4. widget-wrapping plugins                (plugins.zsh)

# Extra completions for tools that ship none. Installed by zsh-plugins-sync.
[[ -d $HOME/.dotfiles/zsh/plugins/zsh-completions/src ]] &&
  fpath=($HOME/.dotfiles/zsh/plugins/zsh-completions/src $fpath)

# compinit rescans every dir in $fpath and re-audits permissions on each start,
# which costs ~160ms now that zsh-completions is in there. Do the full run at
# most once a day and trust the cache otherwise (-C skips the scan and audit).
autoload -U compinit
_zcompdump=$HOME/.zcompdump
# NB: the staleness test has to be an array assignment. Inside [[ ]] zsh does
# no filename generation, so the (N.mh+24) qualifier would never be applied and
# the slow branch would always win.
_zcompdump_stale=($_zcompdump(N.mh+24))
if [[ ! -f $_zcompdump ]] || (( $#_zcompdump_stale )); then
  compinit -u -d $_zcompdump
  # Byte-compile so every other shell today loads the dump faster. Done inline
  # rather than backgrounded: this branch runs at most once a day, and a
  # disowned job here is unreliable when the shell exits soon after.
  zcompile -R -- $_zcompdump
else
  compinit -C -d $_zcompdump
fi
unset _zcompdump _zcompdump_stale

zmodload zsh/complist

# GNU ls reads LS_COLORS; the LSCOLORS in .zshrc is the BSD/macOS spelling and
# does nothing here. Completion colouring below depends on this being set.
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

setopt auto_menu          # show the completion menu on a second tab
setopt auto_param_slash   # append / when completing a directory
setopt complete_in_word   # complete from the cursor, not just end of word
setopt always_to_end      # ...but move the cursor to the end afterwards

# fzf-tab needs zsh's own menu off so it can capture the unambiguous prefix.
zstyle ':completion:*' menu no

# Case-insensitive, then partial-word, then substring matching.
# 'dow<TAB>' finds Downloads, 'f.b<TAB>' finds foo.bar, 'bar<TAB>' finds foobar.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and label each group, which is most of what makes fish's
# completions feel informative.
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'
zstyle ':completion:*:messages'     format '%F{cyan}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches: %d%f'

# Colour file matches the same way ls does
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Complete . and .. so 'cd ../<TAB>' behaves
zstyle ':completion:*' special-dirs true

# Cache the slow ones (apt, dpkg, ...)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh/compcache
[[ -d $HOME/.cache/zsh ]] || mkdir -p $HOME/.cache/zsh

# Complete process names for kill. No 'menu select' here on purpose: that would
# override the global 'menu no' and hand kill back to zsh's menu, so kill would
# be the one command that does not use fzf-tab.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

# Don't suggest a file that is already on the line
zstyle ':completion:*:(rm|cp|mv|diff):*' ignore-line other
