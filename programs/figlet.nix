{ pkgs, ... }:
let
  custom-fonts = pkgs.fetchFromGitHub {
    owner = "xero";
    repo = "figlet-fonts";
    rev = "5c250192890856486be8a85085e7915b1b655f3e";
    hash = "sha256-wT1DjM+3+UasAm2IHavBXs0R8eNMJn9uLtWSqwS+XU0=";
  };
in {
  nixpkgs.overlays = [
    (final: prev: {
      figlet = prev.figlet.overrideAttrs (final: prev: {
        contributed = pkgs.symlinkJoin {
          name = "fonts";
          paths = [
            prev.contributed
            custom-fonts
          ];
        };
      });
    })
  ];
}
