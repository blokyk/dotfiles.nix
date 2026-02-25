{ pkgs, ... }:
let
  scripts = pkgs.callValue ./scripts.nix {};
in {
  home.packages = builtins.attrValues scripts;
}
