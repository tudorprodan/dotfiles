# dotfiles

My dotfiles. Symlinked into `$HOME`.

The zsh plugins live in `zsh/plugins/` as git submodules. This repo records the
exact commit of each one, so a plugin's code only changes when I deliberately
move the pin and commit it — nothing fetches anything at shell startup.

## Clone on a new box

```sh
git clone git@github.com:tudorprodan/dotfiles.git ~/.dotfiles
~/.dotfiles/linkem
```

`linkem` makes the symlinks, adds `skip_global_compinit=1` to `~/.zshenv` (so
`/etc/zsh/zshrc` does not run its own slow `compinit` before ours), and fills in
the plugin submodules. It **overwrites** anything already at those paths, so on
a box with existing config, move what you want to keep first.

If the plugin directories are empty, zsh prints a reminder on startup. Fill them
in with:

```sh
git -C ~/.dotfiles submodule update --init
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

## Why master, and how to pin a release instead

All four plugins are tracked on `master`. None of them publishes a separate
stable branch, and every upstream README documents installation as a plain
`git clone` with no branch argument, so `master` is the stable line in each
case. The other branches are development ones (`develop`, `fixes/*`,
`features/*` on zsh-autosuggestions, `approximate` and `refactor/*` on fzf-tab,
`ci` on fast-syntax-highlighting) and should be left alone.

Tags are the only real alternative, and are not worth it everywhere:
zsh-completions is a rolling collection whose last tag sits 167 commits behind
master, and fast-syntax-highlighting tagged v1.56 on the same day as its last
master commit.

To pin one submodule to a release tag anyway:

```sh
cd ~/.dotfiles/zsh/plugins/fzf-tab
git fetch --tags
git checkout v1.3.0
cd ~/.dotfiles
git add zsh/plugins/fzf-tab
git commit -m "pin fzf-tab to v1.3.0"
```

Note that `git submodule update --remote` would pull that submodule back to
master tip, because `--remote` follows the `branch` setting in `.gitmodules`.
If you pin a tag, either drop that submodule's `branch` line, or update the
rest by naming them explicitly:

```sh
git -C ~/.dotfiles submodule update --remote zsh/plugins/zsh-completions
```

To see what a pinned submodule is missing relative to master:

```sh
git -C ~/.dotfiles/zsh/plugins/fzf-tab log --oneline HEAD..origin/master
```

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
