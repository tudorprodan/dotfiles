## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

# SAVEHIST is what gets written; keeping HISTSIZE (in-memory) larger leaves
# hist_expire_dups_first room to drop duplicates before saving.
HISTSIZE=120000
SAVEHIST=100000

case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups  # drop an older copy of a command anywhere in the
                             # list, not just when it repeats back to back
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history         # share command history data
setopt hist_reduce_blanks    # collapse redundant whitespace before saving
setopt hist_find_no_dups     # do not show the same line twice when searching
