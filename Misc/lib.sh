#!/usr/bin/env bash
#   WildfootW's dotfiles — shared library
#   GitHub: github.com/WildfootW
#
#   All actionable logic lives here as functions. Both setup.sh (one-shot
#   first-run installer) and maintenance.sh (interactive menu) source this
#   file, so there is a single source of truth for every command that runs.
#
#   Targets: Ubuntu 24.04 (apt) and RHEL/Rocky/Alma (dnf). macOS dropped.

# ---------------------------------------------------------------------------
# Paths & environment
# ---------------------------------------------------------------------------
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$LIB_DIR")"
# Allow callers (setup.sh) to override; default to the obvious values.
: "${HomeDirectory:=$HOME}"
: "${CurrentUser:=$USER}"

GIT_EMAIL="wildfootw@wildfoo.tw"
GIT_NAME="WildfootW"
NERD_FONT_VERSION="v3.4.0"
NERD_FONT_NAME="IosevkaTerm"   # IosevkaTerm.tar.xz from the Nerd Fonts release
APT_MIRROR="https://mirror.twds.com.tw/ubuntu"   # Taiwan mirror (faster locally)

# Detect the distribution (for display) and the package-manager family.
# shellcheck source=check_distribution.sh
source "$LIB_DIR/check_distribution.sh"
if   command -v apt-get >/dev/null 2>&1; then PKG_FAMILY="apt"
elif command -v dnf     >/dev/null 2>&1; then PKG_FAMILY="dnf"
elif command -v yum     >/dev/null 2>&1; then PKG_FAMILY="yum"
else PKG_FAMILY="unknown"; fi

# ---------------------------------------------------------------------------
# Output & interaction helpers
# ---------------------------------------------------------------------------
info()  { printf '\033[1;32m[*]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
err()   { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; }
title() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

# confirm "message"  -> returns 0 on yes, 1 on no (default: no)
confirm() {
    local reply
    printf '\033[1;34m[?]\033[0m %s [y/N] ' "$1"
    read -r reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# run_cmd "description" cmd args...  -> print the command, confirm, then run
run_cmd() {
    local desc="$1"; shift
    printf '    %s\n      $ %s\n' "$desc" "$*"
    if confirm "Run this?"; then
        "$@"
    else
        warn "skipped"
    fi
}

# pkg_install pkg...  -> install packages with the detected package manager
pkg_install() {
    case "$PKG_FAMILY" in
        apt) sudo apt-get install -y "$@" ;;
        dnf) sudo dnf install -y "$@" ;;
        yum) sudo yum install -y "$@" ;;
        *)   err "Unknown package manager; install manually: $*"; return 1 ;;
    esac
}

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------

# [M] Switch the Ubuntu APT mirror to a faster (Taiwan) one.
# Handles both the new deb822 file (24.04: ubuntu.sources) and the legacy
# sources.list. Backs up once before editing; idempotent on re-run.
set_apt_mirror() {
    title "Switch APT mirror -> $APT_MIRROR"
    if [ "$PKG_FAMILY" != "apt" ]; then
        warn "Not an apt-based system; mirror switch skipped."
        return 0
    fi
    local files=() f
    [ -f /etc/apt/sources.list.d/ubuntu.sources ] && files+=("/etc/apt/sources.list.d/ubuntu.sources")
    [ -f /etc/apt/sources.list ] && files+=("/etc/apt/sources.list")
    if [ ${#files[@]} -eq 0 ]; then
        err "No apt sources file found (/etc/apt/sources.list[.d/ubuntu.sources])."
        return 1
    fi
    echo "  Files to rewrite (archive + security hosts -> $APT_MIRROR):"
    printf '    %s\n' "${files[@]}"
    confirm "Back up and switch to $APT_MIRROR?" || return 0
    for f in "${files[@]}"; do
        sudo cp -n "$f" "$f.dotfiles.bak"   # keep the first (pristine) backup
        sudo sed -i -E \
            -e "s#https?://[a-z0-9.-]*archive\.ubuntu\.com/ubuntu#$APT_MIRROR#g" \
            -e "s#https?://security\.ubuntu\.com/ubuntu#$APT_MIRROR#g" \
            "$f"
        info "updated $f (backup: $f.dotfiles.bak)"
    done
    run_cmd "Refresh package lists from the new mirror" sudo apt-get update
}

# [1] System packages (distro-aware)
install_packages() {
    title "Install system packages ($distribution / $PKG_FAMILY)"
    case "$PKG_FAMILY" in
        apt)
            info "Refreshing package lists..."
            sudo apt-get update
            pkg_install zsh tmux git curl unzip xclip build-essential universal-ctags fzf
            ;;
        dnf|yum)
            run_cmd "Enable EPEL (universal-ctags, neovim, fzf live here)" \
                pkg_install epel-release
            pkg_install zsh tmux git curl unzip xclip "@Development Tools" ctags fzf
            ;;
        *) err "Unsupported distro for automatic package install."; return 1 ;;
    esac
    ensure_locale
    install_neovim
}

# zshrc exports LANG/LC_ALL=en_US.UTF-8 — make sure that locale actually exists,
# otherwise perl/locale-aware tools warn and fall back to the C locale.
ensure_locale() {
    if locale -a 2>/dev/null | grep -qiE 'en_US\.utf-?8'; then
        info "locale en_US.UTF-8 already generated"
        return 0
    fi
    title "Generate en_US.UTF-8 locale"
    case "$PKG_FAMILY" in
        apt)
            pkg_install locales
            sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 2>/dev/null
            sudo locale-gen en_US.UTF-8
            sudo update-locale LANG=en_US.UTF-8
            ;;
        dnf|yum)
            pkg_install glibc-langpack-en
            ;;
    esac
}

# Neovim: official release tarball into ~/.local (reliable & current on every
# distro). We do NOT use the apt PPA: neovim-ppa/stable has no `neovim` build
# for Ubuntu 24.04 (noble) — only libvterm — so apt would silently keep the
# distro's 0.9.5, which is too old for this Lua config (blink.cmp/treesitter).
# The tarball is self-contained (bundles its runtime) and needs no sudo/FUSE.
install_neovim() {
    title "Install Neovim (official release tarball -> ~/.local)"
    if command -v nvim >/dev/null 2>&1; then
        info "nvim found: $(nvim --version | head -1)"
        confirm "Reinstall / upgrade to latest release anyway?" || return 0
    fi
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    local dest="$HomeDirectory/.local/share/nvim-release"
    local tmp
    tmp="$(mktemp -d)"
    info "Downloading $url"
    if ! curl -fL "$url" -o "$tmp/nvim.tar.gz"; then
        err "Download failed."
        rm -rf "$tmp"
        return 1
    fi
    rm -rf "$dest"
    mkdir -p "$dest" "$HomeDirectory/.local/bin"
    tar -xzf "$tmp/nvim.tar.gz" -C "$dest" --strip-components=1
    ln -sf "$dest/bin/nvim" "$HomeDirectory/.local/bin/nvim"
    rm -rf "$tmp"
    info "Installed $("$HomeDirectory/.local/bin/nvim" --version | head -1) -> ~/.local/bin/nvim"
    info "Ensure ~/.local/bin precedes /usr/bin in PATH (zshrc already does this)."
}

# [2] Submodules (oh-my-zsh, oh-my-tmux)
init_submodules() {
    title "Init & update git submodules"
    git -C "$DOTFILES_ROOT" submodule sync --recursive
    git -C "$DOTFILES_ROOT" submodule update --init --recursive
}

# [3] Symlink dotfiles into $HOME. Single source-of-truth table.
link_dotfiles() {
    title "Link dotfiles into $HomeDirectory"
    # The shell config references $HOME/dotfiles, so make sure it resolves here
    # (no-op when the repo already lives at ~/dotfiles).
    if [ "$(readlink -f "$DOTFILES_ROOT")" != "$(readlink -f "$HomeDirectory/dotfiles")" ]; then
        _link_one "$DOTFILES_ROOT" "$HomeDirectory/dotfiles"
    fi
    # src (relative to repo)            : dst (relative to $HomeDirectory)
    local links=(
        "Zshell/zshrc:.zshrc"
        "Zshell/starship.toml:.config/starship.toml"
        "Tmux/tmux.conf:.tmux.conf"
        "Tmux/tmux.conf.local:.tmux.conf.local"
        "SecureShell/ssh-config:.ssh/config"
        "Neovim:.config/nvim"
    )
    local pair src dst
    for pair in "${links[@]}"; do
        src="$DOTFILES_ROOT/${pair%%:*}"
        dst="$HomeDirectory/${pair##*:}"
        _link_one "$src" "$dst"
    done
}

_link_one() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        if [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
            info "already linked: $dst"
            return
        fi
        warn "conflict: $dst is a symlink to $(readlink "$dst")"
    elif [ -e "$dst" ]; then
        warn "conflict: $dst already exists and is not our symlink"
    else
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
        info "linked $dst -> $src"
        return
    fi
    # Conflicting file/symlink: offer to back it up and replace, so a stray rc
    # (e.g. one an installer created) can't silently shadow the dotfile.
    if confirm "Back up to ${dst}.bak and replace with the dotfiles symlink?"; then
        mv "$dst" "$dst.bak"
        ln -s "$src" "$dst"
        info "backed up to $dst.bak and linked $dst -> $src"
    else
        warn "left in place: $dst"
    fi
}

# [4] Toolchains: fnm (node), uv (python), starship (prompt)
install_toolchains() {
    title "Install toolchains (fnm / uv / starship)"
    mkdir -p "$HomeDirectory/.local/bin"

    if command -v fnm >/dev/null 2>&1; then
        info "fnm already installed"
    else
        # Install into ~/.local/bin (on PATH) and skip the installer's shell
        # edits — zshrc already runs `fnm env`. Without --install-dir the binary
        # lands in ~/.local/share/fnm, which is NOT on PATH.
        run_cmd "Install fnm (Node version manager)" \
            bash -c "curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir '$HomeDirectory/.local/bin' --skip-shell"
    fi

    if command -v uv >/dev/null 2>&1; then
        info "uv already installed"
    else
        # INSTALLER_NO_MODIFY_PATH stops uv from creating/appending to ~/.zshrc
        # (zshrc already has ~/.local/bin on PATH).
        run_cmd "Install uv (Python toolchain)" \
            bash -c 'curl -LsSf https://astral.sh/uv/install.sh | INSTALLER_NO_MODIFY_PATH=1 sh'
    fi

    # Node LTS via fnm — needed by Node-based LSP servers (pyright,
    # bash-language-server) that mason installs inside Neovim.
    if command -v fnm >/dev/null 2>&1; then
        if fnm ls 2>/dev/null | grep -qE 'v[0-9]+\.'; then
            info "fnm: a Node version is already installed"
        else
            run_cmd "Install Node LTS via fnm and set it as the default" \
                bash -c 'eval "$(fnm env)"; fnm install --lts && fnm default "$(fnm ls | grep -oE "v[0-9]+\.[0-9]+\.[0-9]+" | tail -1)"'
        fi
    fi

    # tree-sitter CLI — nvim-treesitter (main branch) builds parsers with it.
    if command -v tree-sitter >/dev/null 2>&1; then
        info "tree-sitter CLI already installed"
    else
        run_cmd "Install tree-sitter CLI to ~/.local/bin" \
            bash -c 'curl -fL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz -o /tmp/ts.gz && gunzip -f /tmp/ts.gz && install -m755 /tmp/ts "$HOME/.local/bin/tree-sitter" && rm -f /tmp/ts'
    fi

    if command -v starship >/dev/null 2>&1; then
        info "starship already installed"
    else
        run_cmd "Install starship prompt to ~/.local/bin" \
            bash -c "curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b '$HomeDirectory/.local/bin'"
    fi
}

# [5] Nerd Font (Iosevka Term, Nerd Fonts v3 release archive)
install_font() {
    title "Install $NERD_FONT_NAME Nerd Font ($NERD_FONT_VERSION)"
    if grep -qi microsoft /proc/version 2>/dev/null; then
        warn "WSL detected: this installs the font inside Linux, but your terminal"
        warn "(Windows Terminal / VS Code) renders with WINDOWS fonts. Install the"
        warn "Nerd Font on Windows too, then set it as the terminal font."
    fi
    if fc-list 2>/dev/null | grep -qi "$NERD_FONT_NAME Nerd Font"; then
        info "$NERD_FONT_NAME Nerd Font already installed"
        confirm "Reinstall anyway?" || return 0
    fi
    local fontdir="$HomeDirectory/.local/share/fonts/$NERD_FONT_NAME"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONT_VERSION/$NERD_FONT_NAME.tar.xz"
    local tmp
    tmp="$(mktemp -d)"
    info "Downloading $url"
    if curl -fL "$url" -o "$tmp/font.tar.xz"; then
        mkdir -p "$fontdir"
        tar -xJf "$tmp/font.tar.xz" -C "$fontdir"
        fc-cache -f "$fontdir" >/dev/null 2>&1
        info "Installed to $fontdir"
    else
        err "Download failed; check the Nerd Fonts release for the current asset name."
    fi
    rm -rf "$tmp"
}

# [6] Neovim plugins (config is symlinked by link_dotfiles)
setup_neovim() {
    title "Setup Neovim (sync lazy.nvim plugins)"
    if ! command -v nvim >/dev/null 2>&1; then
        warn "nvim not found; run 'Install system packages' first."
        return 1
    fi
    run_cmd "Bootstrap & sync plugins (lazy.nvim)" \
        nvim --headless "+Lazy! sync" +qa
    info "LSP servers/treesitter parsers install on first real launch via mason/treesitter."
}

# [7] ZSH plugins + default shell
setup_zsh() {
    title "Setup ZSH custom plugins + default shell"
    local custom="$DOTFILES_ROOT/Zshell/ohmyzsh/custom/plugins"
    _clone_if_absent "https://github.com/zsh-users/zsh-autosuggestions" \
        "$custom/zsh-autosuggestions"
    _clone_if_absent "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
        "$custom/zsh-syntax-highlighting"

    if [ "$(basename "$SHELL")" = "zsh" ]; then
        info "default shell is already zsh"
    elif confirm "Change default shell to zsh for $CurrentUser?"; then
        chsh -s "$(command -v zsh)" "$CurrentUser"
    fi
}

_clone_if_absent() {
    local url="$1" dst="$2"
    if [ -d "$dst" ]; then
        info "already present: $(basename "$dst")"
    else
        git clone --depth 1 "$url" "$dst"
    fi
}

# [8] Git global configuration
configure_git() {
    title "Configure git (global)"
    git config --global user.email "$GIT_EMAIL"
    git config --global user.name "$GIT_NAME"
    git config --global color.ui true
    git config --global core.editor nvim
    git config --global alias.co commit
    git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    git config --global push.default simple
    git config --global pull.rebase false
    git config --global init.defaultBranch main
    git config --global core.excludesfile "$DOTFILES_ROOT/Git/gitignore"
    info "git global config applied"
}

# [9] SSH key — single default-named ed25519 used everywhere
setup_ssh() {
    title "Setup SSH key (~/.ssh/id_ed25519)"
    local keyfile="$HomeDirectory/.ssh/id_ed25519"
    mkdir -p "$HomeDirectory/.ssh"
    chmod 700 "$HomeDirectory/.ssh"

    if [ -f "$keyfile" ]; then
        info "Key already exists: $keyfile (not overwriting)"
    elif confirm "Generate a new ed25519 key (you will be asked for a passphrase)?"; then
        # No -N "" : prompt interactively so the key is passphrase-protected.
        ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$keyfile"
    else
        return 0
    fi

    if [ -f "$keyfile.pub" ]; then
        echo "  Public key (add to GitHub / authorized_keys):"
        echo "  +--------------------------------------------------------------+"
        sed 's/^/    /' "$keyfile.pub"
        echo "  +--------------------------------------------------------------+"
        echo "  ssh-config uses the default name + 'AddKeysToAgent yes', so the"
        echo "  agent loads it on first use — no ssh-add in your shell rc needed."
    fi
}

# [10] Directory structure
make_dirs() {
    title "Create directory structure"
    "$LIB_DIR/make_my_workplace_dir.sh"
}

# Read-only audit — safe to run anytime, writes nothing.
health_check() {
    title "Health check (read-only)"

    echo "Binaries:"
    local bin
    for bin in zsh tmux nvim git curl fzf ctags fnm node uv tree-sitter starship; do
        if command -v "$bin" >/dev/null 2>&1; then
            printf '  \033[1;32m✓\033[0m %-10s %s\n' "$bin" "$(command -v "$bin")"
        else
            printf '  \033[1;31m✗\033[0m %-10s missing\n' "$bin"
        fi
    done

    echo "Submodules:"
    _check_path "oh-my-zsh"  "$DOTFILES_ROOT/Zshell/ohmyzsh/oh-my-zsh.sh"
    _check_path "oh-my-tmux" "$DOTFILES_ROOT/Tmux/oh-my-tmux/tmux.conf"

    echo "Symlinks:"
    # dst : expected source (relative to repo) — verify it really points to ours,
    # not just that something exists there (a stray file would be a false pass).
    local links=(
        ".zshrc:Zshell/zshrc"
        ".config/starship.toml:Zshell/starship.toml"
        ".tmux.conf:Tmux/tmux.conf"
        ".ssh/config:SecureShell/ssh-config"
        ".config/nvim:Neovim"
    )
    local pair dst want
    for pair in "${links[@]}"; do
        dst="$HomeDirectory/${pair%%:*}"
        want="$DOTFILES_ROOT/${pair##*:}"
        if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
            printf '  \033[1;31m✗\033[0m %s (missing)\n' "$dst"
        elif [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$want")" ]; then
            printf '  \033[1;32m✓\033[0m %s\n' "$dst"
        else
            printf '  \033[1;33m!\033[0m %s (exists but is NOT our symlink — run Link dotfiles)\n' "$dst"
        fi
    done

    echo "Fonts:"
    if fc-list 2>/dev/null | grep -qi "Nerd Font"; then
        printf '  \033[1;32m✓\033[0m Nerd Font present\n'
    else
        printf '  \033[1;31m✗\033[0m no Nerd Font found\n'
    fi
}

_check_path() {
    if [ -e "$2" ]; then
        printf '  \033[1;32m✓\033[0m %-12s initialized\n' "$1"
    else
        printf '  \033[1;31m✗\033[0m %-12s not initialized (run submodule update)\n' "$1"
    fi
}

# Full install used by setup.sh and the [A] menu entry.
run_all() {
    set_apt_mirror
    install_packages
    init_submodules
    # Link BEFORE installing toolchains: some installers (uv) would otherwise
    # create a plain ~/.zshrc first, which the non-destructive link step then
    # skips, leaving the shell unconfigured.
    link_dotfiles
    install_toolchains
    install_font
    setup_zsh
    configure_git
    setup_ssh
    make_dirs
    setup_neovim
    title "All steps complete"
    info "Open a new terminal (or 'exec zsh') to pick up the new shell config."
}
