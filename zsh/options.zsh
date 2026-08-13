## Shell options

## Directory navigation

setopt auto_pushd         # every cd pushes the old directory onto the stack
setopt pushd_ignore_dups  # ...without the stack filling up with duplicates
setopt pushd_silent       # ...and without printing the stack on every cd

# auto_pushd is what makes 'cd -<TAB>' offer a menu of recent directories.

## Quality of life

setopt interactive_comments  # allow trailing '# comments' on the command line, so pasted build instructions do not error out
setopt no_beep
setopt no_flow_control       # free ctrl-s / ctrl-q, which otherwise freeze the terminal when hit by accident
setopt glob_complete         # 'foo*<TAB>' cycles the matches instead of expanding them all onto the line at once

# extended_glob is deliberately left off. It makes '^' a pattern character, so
# 'git show HEAD^' fails with "no matches found" unless the ref is quoted. Turn
# it on if you want ~, ^ and (#i) patterns more than you want unquoted git refs.
# setopt extended_glob
