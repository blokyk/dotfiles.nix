# the distinction of which builtins are in the global scope
# vs which ones aren't is very arbitrary, and i don't
# particularly like it, so this just injects everything from
# `builtins` into the global scope
{ currentSystem, ... }@info:
final: prev:
let
  # we have to remove keywords from the new scope,
  # because otherwise lix will complain about
  # "shadowing symbols used in internal expressions"
  keywords = [
    "null"
    "true"
    "false"
  ];
in
  removeAttrs
    builtins
    keywords
