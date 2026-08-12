# dotfiles

My dotfiles. Symlinked into `$HOME`.

The zsh plugins live in `zsh/plugins/` as git submodules. This repo records the
exact commit of each one, so a plugin's code only changes when I deliberately
move the pin and commit it — nothing fetches anything at shell startup.

## Clone on a new box

```sh
git clone --recurse-submodules git@github.com:tudorprodan/dotfiles.git ~/.dotfiles
```

If the repo is already cloned without submodules, the plugin directories will be
empty and zsh will print a reminder on startup. Fill them in with:

```sh
git -C ~/.dotfiles submodule update --init --recursive
```

Then link the files into `$HOME`, e.g.:

```sh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh ~/.zsh
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```

`~/.zshenv` is deliberately *not* a symlink, but it needs one line so that
`/etc/zsh/zshrc` does not run its own slow `compinit` before ours:

```sh
echo 'skip_global_compinit=1' | cat - ~/.zshenv > /tmp/z && mv /tmp/z ~/.zshenv
```

## Update one plugin to the top of master

Each submodule tracks `master` (set via `branch = master` in `.gitmodules`), so
`--remote` means "whatever master points at right now":

```sh
git -C ~/.dotfiles submodule update --remote zsh/plugins/zsh-autosuggestions
```

That moves the working tree only. Review what you are about to pin, then commit
the new pin:

```sh
cd ~/.dotfiles
git diff --submodule=log zsh/plugins/zsh-autosuggestions
git add zsh/plugins/zsh-autosuggestions
git commit -m "bump zsh-autosuggestions"
```

## Update all plugins to the top of master

```sh
git -C ~/.dotfiles submodule update --remote
```

Same review-then-commit step, across everything that moved:

```sh
cd ~/.dotfiles
git diff --submodule=log
git add zsh/plugins
git commit -m "bump zsh plugins"
```

Reload the shell afterwards with `exec zsh`.

## Add a plugin

```sh
cd ~/.dotfiles
git submodule add -b master https://github.com/<user>/<plugin>.git zsh/plugins/<plugin>
git commit -m "add <plugin>"
```

Then add its name to `_ZSH_PLUGIN_LOAD` in `zsh/plugins.zsh`. Order in that list
matters: `fzf-tab` has to load after `compinit` but before anything that wraps
zle widgets, and the widget wrappers (`fast-syntax-highlighting`,
`zsh-autosuggestions`) go last.

## Remove a plugin

```sh
cd ~/.dotfiles
git submodule deinit -f zsh/plugins/<plugin>
git rm zsh/plugins/<plugin>
rm -rf .git/modules/zsh/plugins/<plugin>
git commit -m "remove <plugin>"
```

## Check what is pinned

```sh
git -C ~/.dotfiles submodule status
```

A leading `-` means not initialised, `+` means the checkout does not match the
recorded pin.
