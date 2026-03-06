# shellcheck shell=bash

# create a new shell/env with a NIX_PATH based on the pins in npins/sources.json

pinsDir="${NPINS_DIRECTORY:-npins}"
if [[ -v 1 ]] && { [[ "$1" = "-d" ]] || [[ "$1" = "--directory" ]]; }; then
    shift
    [[ -v 1 ]] || (echo "Option '--directory' expected an argument"; exit 1)
    pinsDir="$1"
    shift
fi

pinsFile="${NPINS_FILE:-$pinsDir/sources.json}"
if [[ -v 1 ]] && { [[ $1 = "-f" ]] || [[ "$1" = "--file" ]]; }; then
    shift
    [[ -v 1 ]] || (echo "Option '--file' expected an argument"; exit 1)
    pinsFile="$1"
    shift
fi

if [[ -v 1 ]] && { [[ "$1" = "--" ]]; }; then
    shift
    argc="$#"
    args=("$@")
    shift $argc
fi

if [[ $# -gt 0 ]]; then
    echo "Unexpected arguments: $*"
    echo "Usage: npins-shell [--directory <npins-dir> | --file <sources.json-file>] [-- <shell args...>]"
    exit 1
fi

NIX_PATH="$(
    set -o errexit -o pipefail;
    for pin in $(npins --lock-file "$pinsFile" show | cut -d' ' -f1 | sed '/^[[:space:]]*$/d' | tr -d ':'); do
        # note: `get-path` doesn't add a newline after its output, so we can just use the
        #       output directly as if it were a normal string (and add a separator after it)
        printf '%s=%s:' "$pin" "$(npins --lock-file "$pinsFile" get-path "$pin")"
    done
)"


# if there *are* args, pass them, otherwise don't
# (yes, i know there's a shorter way to do this, but it's harder to read/understand)
if [[ -n "${args[*]}" ]]; then
    # shellcheck disable=SC2086 # we want $args to fully expand
    env NIX_PATH="$NIX_PATH" "$SHELL" "${args[@]}"
else
    env NIX_PATH="$NIX_PATH" "$SHELL"
fi
