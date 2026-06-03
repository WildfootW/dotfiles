#!/usr/bin/env bash
#   WildfootW's dotfiles — interactive maintenance tool
#   GitHub: github.com/WildfootW
#
#   Day-to-day maintenance menu. A superset of setup.sh: every install step is
#   available individually, plus a read-only health check. All logic lives in
#   Misc/lib.sh (shared with setup.sh).

set -o pipefail

ScriptLocation="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
# shellcheck source=Misc/lib.sh
source "$ScriptLocation/Misc/lib.sh"

menu() {
    cat <<EOF

  WildfootW dotfiles — maintenance   ($distribution / $PKG_FAMILY)
  ---------------------------------------------------------------
   [1]  Install system packages      (apt / dnf, incl. Neovim)
   [2]  Init & update git submodules
   [3]  Link dotfiles into \$HOME      (symlink, never overwrites)
   [4]  Install toolchains            (fnm / uv / starship)
   [5]  Install Nerd Font             ($NERD_FONT_NAME $NERD_FONT_VERSION)
   [6]  Setup Neovim                  (lazy.nvim sync)
   [7]  Setup ZSH plugins + chsh
   [8]  Configure git
   [9]  Setup SSH key                 (~/.ssh/id_ed25519)
   [10] Create dirs                   (Workplace / Cybersecurity / .local/bin)
   [M]  Switch APT mirror             (-> mirror.twds.com.tw, Ubuntu only)
   [A]  Run ALL (full install)
   [H]  Health check / audit          (read-only)
   [Q]  Quit
  ---------------------------------------------------------------
EOF
}

while true; do
    menu
    printf 'Choose: '
    read -r choice
    case "$choice" in
        1)  install_packages ;;
        2)  init_submodules ;;
        3)  link_dotfiles ;;
        4)  install_toolchains ;;
        5)  install_font ;;
        6)  setup_neovim ;;
        7)  setup_zsh ;;
        8)  configure_git ;;
        9)  setup_ssh ;;
        10) make_dirs ;;
        [Mm]) set_apt_mirror ;;
        [Aa]) run_all ;;
        [Hh]) health_check ;;
        [Qq]) exit 0 ;;
        *)  warn "Unknown choice: $choice" ;;
    esac
done
