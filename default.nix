let
  injectImport = import ./npins/inject.nix (pins: {
    zoeee.nixpkgs = pins.nixpkgs;
    home-manager.nixpkgs = pins.nixpkgs;
  });
in
  injectImport ./bootstrap.nix
