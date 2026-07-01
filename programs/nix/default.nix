{ config, lib, pins, ... }:
let
  # we don't want to inject every pin (e.g. figlet-font) into the system's nix path
  systemWidePins = {
    inherit (pins)
      home-manager
      nixpkgs
      zoeee
      ;
  };
in {
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
        "lix-custom-sub-commands"
      ];

      repl-overlays = [
        ./add-builtins.nix
      ];
    };

    # inject all the pins as flakes in the registry
    registry =
      let
        pinToFlake = name: path: {
          inherit name;
          value = {
            to = {
              type = "path";
              path = toString path;
            };
          };
        };
      in lib.mapAttrs' pinToFlake systemWidePins;
  };

  # make sure the nix used by the user is nix.package and not the system-wide one
  home.packages = [ config.nix.package ];

  # nix.settings.channels doesn't work for some reason :(
  home.sessionVariables.NIX_PATH = import <self/npins/mk-nix-path.nix> { pins = systemWidePins; };
}
