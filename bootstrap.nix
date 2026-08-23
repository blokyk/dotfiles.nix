# this file is used to make an eval/build of a typical home-manager generation
# without using the `home-manager` command/CLI.
# it should be in `default.nix`, but unfortunately, that is already taken
# by the frozenpins injector fragment.
pins:
let
  pkgs = import <nixpkgs> {};

  topModule = import <home-manager/modules> {
    configuration = ./home2.nix;

    pkgs = pkgs;
    lib = pkgs.lib; # todo: add our own util functions here

    minimal = false;
    check = true;

    extraSpecialArgs = {
      inherit pins;

      # since HM specializations are extremely slow and inconvenient,
      # (because they evaluate and build the config for each specialization),
      # we instead just use the $HOST variable and then use a bunch of `mkIf`
      # and such to shape the config however we want
      hostname =
        let
          # fixme: why the hell can't we use $HOST normally???
          hostEnv = builtins.getEnv "HOST";
          hostFile = pkgs.lib.fileContents "/etc/hostname"; # strip ending '\n'
        in
          if hostEnv != "" then
            hostEnv
          else
            hostFile;
    };
  };
in {
  inherit (topModule)
    activationPackage
    config
    pkgs
    options
    ;
}
