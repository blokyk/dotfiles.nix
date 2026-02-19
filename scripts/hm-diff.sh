# shellcheck shell=bash

# diff the current hm closure w/ the last, using lix-diff
# optionally, instead of using the last generation, you can give the number
# of generations to go back for the diff (eg 'hm-diff 2' = 'hm-diff HEAD~2')

gen_paths="$(home-manager generations | cut -d' ' -f7)"
curr="$(echo "$gen_paths" | head -n1)"
prev="$(echo "$gen_paths" | awk "NR==1+${1:-1}")"
lix-diff "$prev" "$curr"