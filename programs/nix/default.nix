{ lib, pins, ... }:
let
  legalPins = lib.filterAttrs (name: _: name != "self") pins;
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
      in lib.mapAttrs' pinToFlake legalPins;
  };

  home.sessionVariables.NIX_PATH = import <self/npins/mk-nix-path.nix> { pins = legalPins; };
}
