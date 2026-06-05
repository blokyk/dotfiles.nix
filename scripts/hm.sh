# shellcheck shell=bash

if [[ -z "${1:-}" ]]; then
    man home-configuration.nix
else
    # fixme: this discards the normal $MANPAGER :(
    MANPAGER="less +'/$1'" man home-configuration.nix
fi
