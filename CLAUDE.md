# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for WildfootW. **Linux only** — Ubuntu 24.04 (apt) and
RHEL / Rocky / Alma (dnf); macOS support was removed. Installation symlinks
configs from this repo into `$HOME` (e.g. `Zshell/zshrc` → `~/.zshrc`). The repo
is expected to resolve at `~/dotfiles`; the installer creates that symlink if
the clone lives elsewhere, because configs reference `$HOME/dotfiles`.

## Entry points & architecture

There is **one source of truth** for all actionable logic: [Misc/lib.sh](Misc/lib.sh).
Two thin entry points source it:

- [setup.sh](setup.sh) — **first-run one-shot**. Prompts for user/home, then runs `run_all`.
- [maintenance.sh](maintenance.sh) — **interactive menu**, a superset of setup. Each menu item calls one lib function; also offers a read-only `health_check`.

`Misc/lib.sh` defines (and both entry points expose):
`install_packages` · `install_neovim` · `init_submodules` · `link_dotfiles` ·
`install_toolchains` (fnm/uv/starship) · `install_font` · `setup_neovim` ·
`setup_zsh` · `configure_git` · `setup_ssh` · `make_dirs` · `health_check` · `run_all`.

When adding an install step, add a function to `Misc/lib.sh` and wire it into
both the `maintenance.sh` menu and (if it belongs in a fresh install) `run_all`.
Do **not** re-create per-component `setup.sh` scripts — that pattern was removed.

Key conventions in `lib.sh`:
- **Distro detection**: `source check_distribution.sh`, then `PKG_FAMILY` is set by probing `apt-get`/`dnf`/`yum`. `pkg_install` dispatches on it.
- **Symlinking**: a single `src:dst` table in `link_dotfiles` drives `_link_one`, which is non-destructive (detects conflicts, never overwrites). Add new links to that table, not as bespoke code.
- **Interactivity**: `confirm "msg"` for y/N; `run_cmd "desc" cmd...` prints a command and confirms before running. All external `curl | sh` installers go through this.

## Shell config

`Zshell/zshrc` is self-contained (no OS branching — both targets are Linux).
oh-my-zsh is the framework, but the **prompt is starship** (`ZSH_THEME=""`,
`eval "$(starship init zsh)"` at the end; config in `Zshell/starship.toml`).
Toolchains are wired here: `fnm env`, `uv` completions, `fzf --zsh`. Distro
differences use `command -v apt-get/dnf` guards. Env vars live in
`Misc/environment_variable.sh` (sourced by zshrc).

Note the modernization swaps: **nvm → fnm**, **pyenv → uv**, **agnoster → starship**.

## Neovim

Lua config under `Neovim/` (`init.lua` + `lua/config/` + `lua/plugins/`), built
on **lazy.nvim** + treesitter + native LSP + blink.cmp. `link_dotfiles` symlinks
the whole `Neovim/` dir to `~/.config/nvim`. There is no python venv anymore.
See [Neovim/README.md](Neovim/README.md) for the old→new plugin map and keymaps.

## SSH

Single key at the **default name** `~/.ssh/id_ed25519` (ssh tries it
automatically). `SecureShell/ssh-config` sets `AddKeysToAgent yes`, so no
`ssh-add` runs in the shell rc. `setup_ssh` generates the key **with an
interactive passphrase** and refuses to overwrite an existing key.

## Other notes

- `Misc/make_my_workplace_dir.sh` creates a flat structure: `~/Workplace`, `~/Cybersecurity`, `~/.local/bin`. Its header's "Copyleft … rights reversed" is an intentional pun, not a typo — leave it.
- `Tmux/oh-my-tmux` and `Zshell/ohmyzsh` are submodules. `oh-my-tmux` is **WildfootW's fork** (upstream gpakosz/.tmux + a `.tmux.conf`→`tmux.conf` rename so the symlinks work + personal `tmux.conf.local`). Do NOT repoint it at upstream; refresh the engine in place (see README "Submodules out of date").
- `Templates/` holds `=template=*` boilerplate; consumed by the `vim-template` plugin via `g:templates_directory` (`~/dotfiles/Templates`).
