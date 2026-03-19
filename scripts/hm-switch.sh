# shellcheck shell=bash

# home-manager switch but much simpler and with nix-output-monitor

# recognize the '--backup EXT' option
if [[ -v 1 ]] && { [[ "$1" = "-b" ]] || [[ "$1" = "--backup" ]]; }; then
    shift
    [[ -v 1 ]] || (echo "Option '--backup' expects an argument"; exit 1)
    export HOME_MANAGER_BACKUP_EXT="$1"
    shift
fi

conf_dir="$HOME/.config/home-manager"

gen_path="$(nom-build --no-out-link "$@" "$conf_dir")"
ret=$?

# if the build failed, exit immediately
if [[ $ret != 0 ]]; then
    exit $ret
fi

# otherwise, launch the activation
"$gen_path"/activate
