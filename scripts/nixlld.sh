# shellcheck shell=bash

# Find packages for missing dynamic libraries of a program
# Requires: nix-locate, nix-index

# By Uğur Erdem Seyfi (@kugurerdem)
# https://github.com/kugurerdem/dotfiles/blob/23f0ae804112672e1c8c334efa126b410ed874d7/home-manager/dotfiles/.local/bin/nixldd

ldd "$1" | awk '{print $1}' | while read -r missing_lib; do
  result=$(
      nix-locate --top-level --minimal --whole-name --at-root "/lib/$missing_lib" \
          | grep -v "(" \
          | sed 's/\.[^.]*$//g' \
          | tr '\n' ' '
      )
  echo -e "$missing_lib:\n $result"
done
