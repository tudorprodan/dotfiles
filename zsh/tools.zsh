## External tool integration
#
# Everything here is guarded, so a machine missing the tool just gets a shell
# without that feature rather than an error.

## fzf -- Ctrl-R history, Ctrl-T files, Alt-C cd
#
# fzf >= 0.48 can print its own integration; older ones (Debian/Ubuntu) ship it
# as files. Only the key bindings are loaded: fzf's completion.zsh provides the
# '**<TAB>' trigger, which fzf-tab supersedes.
# The [[ -t 0 ]] guard matters: fzf's key-bindings.zsh saves and restores the
# shell options, and restoring 'zle' fails noisily in a shell with no terminal,
# e.g. 'zsh -i -c ...' from a script. Testing -o zle does not work here, it is
# still set in that case.
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

  # Use fd for the file/directory widgets: respects .gitignore and skips .git,
  # which matters in big source trees.
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
  # These must be exported or less, a child process, never sees them. Each one
  # forks tput, so only boxes without bat pay for them.
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
# --cmd j keeps the autojump muscle memory: 'j foo' jumps, 'ji foo' picks
# interactively. Drop the flag to use the upstream default of 'z' / 'zi'.
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd j)"
fi
