let
  injector = import ./npins/inject.nix (pins: {
    zoeee.nixpkgs = pins.nixpkgs;
    home-manager.nixpkgs = pins.nixpkgs;
  });

  hm = injector.pins.home-manager;
in
  injector.import (hm + "/home-manager/home-manager.nix") {
    confPath = ./home2.nix;
  }
