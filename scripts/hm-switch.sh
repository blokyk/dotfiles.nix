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

# make sure the session is interactive if --debugger is used
if [[ "$*" =~ "--debugger" ]]; then
    front_end=nix
else
    front_end=nom
fi

res_file="$(mktemp --dry-run "/tmp/hm-result-XXXX")"
$front_end build -f "$conf_dir" activationPackage --out-link "$res_file" "$@"

# thanks to `errexit`, this will only execute if the build succeeded
"$res_file"/activate

rm "$res_file"
