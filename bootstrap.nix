# this file is used to make an eval/build of a typical home-manager generation
# without using the `home-manager` command/CLI.
# it should be in `default.nix`, but unfortunately, that is already taken
# by the frozenpins injector fragment.
pins:
let
  pkgs = import <nixpkgs> {};
  env = import <home-manager/modules> {
    configuration = ./home2.nix;

    pkgs = pkgs;
    lib = pkgs.lib; # todo: add our own util functions here

    minimal = false;
    check = true;

    extraSpecialArgs = {
      inherit pins;
    };
  };
in {
  inherit (env)
    activationPackage
    config
    pkgs
    options
    ;
}
