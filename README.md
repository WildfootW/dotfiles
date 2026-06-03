# dotfiles

WildfootW's personal dotfiles. **Linux only** — Ubuntu 24.04 (apt) and
RHEL / Rocky / Alma (dnf). macOS support has been removed.

Installation symlinks the configs in this repo into `$HOME` (e.g.
`Zshell/zshrc` → `~/.zshrc`). The repo is expected to resolve at `~/dotfiles`
(the installer creates that symlink if you cloned it elsewhere).

## Components

| Tool    | What you get |
|---------|--------------|
| Zsh     | oh-my-zsh + **starship** prompt, autosuggestions, syntax highlighting |
| Neovim  | Lua config: **lazy.nvim** + treesitter + native LSP + blink.cmp (see [Neovim/README.md](Neovim/README.md)) |
| Tmux    | [oh-my-tmux](https://github.com/gpakosz/.tmux) (submodule) |
| Git     | global config + aliases |
| SSH     | single `~/.ssh/id_ed25519` key, `AddKeysToAgent yes` |
| Toolchains | **fnm** (Node), **uv** (Python), via shell init |

## Install

```bash
git clone https://github.com/WildfootW/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh          # first-run one-shot: full install end to end
```

After cloning over HTTPS you can switch the remote to SSH:

```bash
git remote set-url origin git@github.com:WildfootW/dotfiles.git
```

### Maintenance

`maintenance.sh` is an interactive menu (a superset of `setup.sh`) for day-to-day
upkeep — re-run any single step, or audit the environment:

```bash
./maintenance.sh
```

```
[1] Install system packages   [6]  Setup Neovim         [M] Switch APT mirror
[2] Init/update submodules     [7]  Setup ZSH + chsh     [A] Run ALL
[3] Link dotfiles              [8]  Configure git        [H] Health check
[4] Install toolchains         [9]  Setup SSH key        [Q] Quit
[5] Install Nerd Font          [10] Create dirs
```

All actual logic lives in [Misc/lib.sh](Misc/lib.sh); both `setup.sh` and
`maintenance.sh` source it.

### What the installer runs

Package install is distro-aware (`Misc/lib.sh` → `install_packages`):

```bash
# Ubuntu
sudo apt-get update
sudo apt-get install -y zsh tmux git curl xclip build-essential universal-ctags fzf

# RHEL / Rocky / Alma
sudo dnf install -y epel-release
sudo dnf install -y zsh tmux git curl xclip ctags fzf "@Development Tools"
```

Neovim is installed from the **official release tarball** into `~/.local`
(symlinked to `~/.local/bin/nvim`) — *not* via apt/dnf. The Ubuntu
`neovim-ppa/stable` has no `neovim` build for 24.04 (noble), so apt would
silently keep the distro's 0.9.5, which is too old for this Lua config. The
tarball is self-contained and needs no sudo. `~/.local/bin` is first on `PATH`
so it wins over any apt-installed `nvim`.

Toolchains are installed via their official installers (printed and confirmed
before running): **fnm**, **uv**, **starship**. A **Nerd Font** (Iosevka Term,
Nerd Fonts v3) is downloaded to `~/.local/share/fonts`.

## Troubleshooting

### SSH key

The key uses the default name `~/.ssh/id_ed25519`, which ssh tries
automatically. `~/.ssh/config` sets `AddKeysToAgent yes`, so the agent loads it
on first use — no `ssh-add` in your shell rc. To load it manually:

```bash
ssh-add ~/.ssh/id_ed25519
```

### Submodules out of date

```bash
git submodule update --init --recursive
```

`Tmux/oh-my-tmux` is **WildfootW's fork** (upstream gpakosz/.tmux + the
no-dot file rename + personal `tmux.conf.local`). Do not repoint it at upstream.
To refresh the engine from upstream while keeping your customizations:

```bash
cd Tmux/oh-my-tmux
git remote add upstream https://github.com/gpakosz/.tmux.git   # once
git fetch upstream
git show upstream/master:.tmux.conf > tmux.conf                # engine only
git commit -am "Update tmux.conf engine to upstream $(git rev-parse --short upstream/master)"
git push origin master                                         # publish the fork
cd ../.. && git add Tmux/oh-my-tmux                            # bump the pointer
```

