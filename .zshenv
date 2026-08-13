# /etc/zsh/zshrc runs its own compinit before ~/.zshrc gets a chance to
skip_global_compinit=1

# Per-machine, not in this repo. Sourced here so every zsh gets it, including
# non-interactive ones like 'ssh box cmd'.
[ -r "$HOME/.shell_init.sh" ] && . "$HOME/.shell_init.sh"
