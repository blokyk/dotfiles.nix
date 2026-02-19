# shellcheck shell=bash

# prints the output path of a given derivation or store path

if [[ "$1" = "" ]]; then
    echo "Prints the store path of the product of this derivation"
    echo "Usage: $0 <drv-path> [output name]"
    echo "The default output will be 'out', but it can be dev, bin, debug, etc."
else
    nix \
        --extra-experimental-features nix-command \
        derivation show "$1"'^*' \
    | jq --exit-status --raw-output ".[].outputs.${2:-out}.path"
fi
