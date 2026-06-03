#!/usr/bin/env bash
#   WildfootW's dotfiles — first-run installer (one-shot)
#   GitHub: github.com/WildfootW
#
#   Use this once on a fresh machine: it runs the full install end to end.
#   For day-to-day maintenance (re-running individual steps, health checks),
#   use ./maintenance.sh instead. Both share the logic in Misc/lib.sh.

set -o pipefail

ScriptLocation="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
# shellcheck source=Misc/lib.sh
source "$ScriptLocation/Misc/lib.sh"

initial() {
    info "Current Username: ($CurrentUser)"
    read -r reply; [ -n "$reply" ] && CurrentUser="$reply"

    info "Home Directory: ($HomeDirectory)"
    read -r reply; [ -n "$reply" ] && HomeDirectory="$reply"

    echo "========================================================"
    echo "Distribution:   $distribution ($PKG_FAMILY)"
    echo "Home Directory: $HomeDirectory"
    echo "Current User:   $CurrentUser"
    echo "Dotfiles Root:  $DOTFILES_ROOT"
    echo "========================================================"
    confirm "Proceed with full install?" || exit 1
}

cat <<'BANNER'

  +------------------------------------------------+
  |                                                |\
  |       WildfootW's dotfile install script       | \
  |                                                | |
  +------------------------------------------------+ |
   \______________________________________________\|

copy from inndy, thank you Inndy!
fork from azdkj532, thank you Squirrel!
BANNER

initial
run_all
