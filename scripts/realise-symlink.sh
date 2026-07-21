#!/bin/bash

# stolen from https://kokada.dev/blog/quick-bits-realise-nix-symlinks/

if { ! [[ -v 1 ]]; } || [[ "$1" =~ "-h"|"--help" ]]; then
    echo "Usage: $(basename "$0") <link...>"
    echo "Replace a symlink with its target (writable) file/directory"
    exit 1
fi

for file in "$@"; do
    if ! [[ -L "$file" ]]; then
        >&2 echo "Not a symlink: $file"
        exit 1
    fi

    # if it's a directory, copy the directory
    if [[ -d "$file" ]]; then
        tmpdir="''${file}.tmp"
        mkdir -p "$tmpdir"
        cp --verbose --recursive "$file"/* "$tmpdir"
        unlink "$file"
        mv "$tmpdir" "$file"
        chmod --changes --recursive +w "$file"
    else
        cp --verbose --remove-destination "$(readlink "$file")" "$file"
        chmod --changes +w "$file"
    fi
done
