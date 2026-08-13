## External tool integration
#
# Everything here is guarded: a machine missing the tool just loses the feature.

## fzf -- Ctrl-R history, Ctrl-T files, Alt-C cd
#
# fzf >= 0.48 prints its own integration; older Debian/Ubuntu ships it as files.
# Only key bindings: fzf's completion.zsh is the '**<TAB>' trigger, superseded
# by fzf-tab. The [[ -t 0 ]] guard stops fzf's option save/restore from failing
# noisily in a shell with no terminal ('zsh -i -c ...' from a script).
if command -v fzf >/dev/null && [[ -t 0 ]]; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    for _f in /usr/share/doc/fzf/examples/key-bindings.zsh \
              /usr/share/fzf/key-bindings.zsh \
              $HOME/.fzf/shell/key-bindings.zsh; do
      [[ -r $_f ]] && { source $_f; break }
    done
    unset _f
  fi

  # fd respects .gitignore and skips .git, which matters in big source trees.
  if command -v fdfind >/dev/null; then
    export FZF_CTRL_T_COMMAND='fdfind --type f --hidden --exclude .git'
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --exclude .git'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
fi

## man pages -- bat if it is installed, else less
#
# Debian installs bat as 'batcat'; the name 'bat' belongs to bacula-console.
if command -v batcat >/dev/null; then
  _bat=batcat
elif command -v bat >/dev/null; then
  _bat=bat
fi

if [[ -n $_bat ]]; then
  export MANPAGER="sh -c 'col -bx | $_bat -l man -p'"
  export MANROFFOPT='-c'   # without it groff >= 1.23 output comes out garbled
else
  # Must be exported or less never sees them. Each forks tput, so only boxes
  # without bat pay for them.
  export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
  export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
  export LESS_TERMCAP_me=$(tput sgr0)
  export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
  export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
  export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
  export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
  export LESS_TERMCAP_mr=$(tput rev)
  export LESS_TERMCAP_mh=$(tput dim)
  export LESS_TERMCAP_ZN=$(tput ssubm)
  export LESS_TERMCAP_ZV=$(tput rsubm)
  export LESS_TERMCAP_ZO=$(tput ssupm)
  export LESS_TERMCAP_ZW=$(tput rsupm)
fi
unset _bat


## zoxide -- frecency based cd, replaces autojump
#
# --cmd j keeps the autojump muscle memory: 'j foo' jumps, 'ji foo' picks.
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd j)"
fi
