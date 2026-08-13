## Completion
#
# Must load before plugins.zsh: fpath, then compinit, then fzf-tab, then the
# widget-wrapping plugins.

[[ -d $HOME/.dotfiles/zsh/plugins/zsh-completions/src ]] &&
  fpath=($HOME/.dotfiles/zsh/plugins/zsh-completions/src $fpath)

# A full compinit rescans and re-audits every $fpath dir, ~160ms. Once a day is
# enough; -C trusts the cache.
autoload -U compinit
_zcompdump=$HOME/.zcompdump
# The staleness test must be an array assignment: [[ ]] does no globbing, so the
# (N.mh+24) qualifier would never apply and the slow branch would always win.
_zcompdump_stale=($_zcompdump(N.mh+24))
if [[ ! -f $_zcompdump ]] || (( $#_zcompdump_stale )); then
  compinit -u -d $_zcompdump
  zcompile -R -- $_zcompdump
else
  compinit -C -d $_zcompdump
fi
unset _zcompdump _zcompdump_stale

# bash's complete/compgen, for tools shipping only a bash completion script.
# ~1.5ms, must follow compinit.
autoload -U +X bashcompinit && bashcompinit

zmodload zsh/complist

# GNU ls reads LS_COLORS; the LSCOLORS in .zshrc is the BSD spelling and does
# nothing here. The list-colors styles below need this.
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

setopt auto_menu          # show the completion menu on a second tab
setopt auto_param_slash   # append / when completing a directory
setopt complete_in_word   # complete from the cursor, not just end of word
setopt always_to_end      # ...but move the cursor to the end afterwards

# fzf-tab needs zsh's own menu off to capture the unambiguous prefix.
zstyle ':completion:*' menu no

# Case-insensitive, then partial-word, then substring:
# 'dow' finds Downloads, 'f.b' finds foo.bar, 'bar' finds foobar.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}%B%d%b%f'
zstyle ':completion:*:messages'     format '%F{cyan}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches: %d%f'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Complete . and .. so 'cd ../<TAB>' behaves
zstyle ':completion:*' special-dirs true

# Cache the slow ones (apt, dpkg, ...)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh/compcache
[[ -d $HOME/.cache/zsh ]] || mkdir -p $HOME/.cache/zsh

# No 'menu select' here on purpose: it would override 'menu no' above and make
# kill the one command that skips fzf-tab.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

# Don't suggest a file that is already on the line
zstyle ':completion:*:(rm|cp|mv|diff):*' ignore-line other
