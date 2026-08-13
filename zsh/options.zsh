## Shell options

## Directory navigation

setopt auto_pushd         # every cd pushes the old directory onto the stack
setopt pushd_ignore_dups  # ...without the stack filling up with duplicates
setopt pushd_silent       # ...and without printing the stack on every cd
                          # auto_pushd is what makes 'cd -<TAB>' work

## Quality of life

setopt interactive_comments  # trailing '# comments', so pasted instructions work
setopt no_beep
setopt no_flow_control       # free ctrl-s / ctrl-q, which otherwise freeze the terminal
setopt glob_complete         # 'foo*<TAB>' cycles matches instead of expanding them all

# Left off: extended_glob makes '^' a pattern character, so 'git show HEAD^'
# fails with "no matches found" unless the ref is quoted.
# setopt extended_glob
