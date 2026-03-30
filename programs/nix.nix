{ lib, pins, ... }: {
  nix = {
    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];

    # inject all the pins as flakes in the registry
    registry =
      let
        pinToFlake = name: path: {
          inherit name;
          value = {
            to = {
              type = "path";
              inherit path;
            };
          };
        };
      in lib.mapAttrs' pinToFlake pins;
  };

  home.sessionVariables.NIX_PATH = import ../npins/mk-nix-path.nix { inherit pins; };
}
