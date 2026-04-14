{ lib, pins, ... }:
let
  # we don't want to inject every pin (e.g. figlet-font) into the system's nix path
  systemWidePins = {
    inherit (pins)
      home-manager
      nixpkgs
      wrapper-manager
      zoeee
      ;
  };
in {
  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
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

  home.sessionVariables.NIX_PATH = import <self/npins/mk-nix-path.nix> { pins = systemWidePins; };
}
