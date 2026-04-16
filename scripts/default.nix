{ pkgs, ... }:
let
  scripts = pkgs.callValue ./scripts.nix {};
in {
  _module.args.scripts = scripts;
  home.packages = builtins.attrValues scripts;
}
