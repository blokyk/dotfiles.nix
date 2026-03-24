# uses the info from the npins `sources.json` to create a NIX_PATH
# value that will use the pinned versions
#
# for example:
#   $ nix eval --raw -f mk-nix-path.nix
#   nixpkgs=/nix/store/...-source:home-manager=/nix/store/...-source
{ pins ? import ./default.nix {} }:
let
  inherit (builtins) attrValues concatStringsSep mapAttrs;

  namedPaths = attrValues (
    mapAttrs
      (name: pin: "${name}=${pin.outPath or pin}")
      pins
  );
in
  concatStringsSep ":" namedPaths
