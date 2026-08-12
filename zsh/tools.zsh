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

## zoxide -- frecency based cd, replaces autojump
#
# --cmd j keeps the autojump muscle memory: 'j foo' jumps, 'ji foo' picks
# interactively. Drop the flag to use the upstream default of 'z' / 'zi'.
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd j)"
fi
