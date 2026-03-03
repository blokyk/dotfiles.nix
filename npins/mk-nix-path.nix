# uses the info from the npins `sources.json` to create a NIX_PATH
# value that will use the pinned versions
#
# for example:
#   $ nix eval --raw -f mk-nix-path.nix
#   nixpkgs=/nix/store/...-source:home-manager=/nix/store/...-source

let
  inherit (builtins) attrValues concatStringsSep mapAttrs;

  pinInfos = import ./default.nix { };

  namedPaths = attrValues (
    mapAttrs
      (name: pin: "${name}=${pin.outPath}")
      pinInfos
  );
in
  concatStringsSep ":" namedPaths
