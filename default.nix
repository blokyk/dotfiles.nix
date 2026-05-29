let
  injector = import ./npins/inject.nix (pins: {
    zoeee.nixpkgs = pins.nixpkgs;
    home-manager.nixpkgs = pins.nixpkgs;

    self = pins // { outPath = ./.; };
  });

  hm = injector.pins.home-manager;
in
  # fixme: this CLEARLY breaks frozenpins (because hm + "..." results in
  # a string and thus erases hm's project-ness), but it seems like frozenpins
  # is also completely and fully broken so you can't actually notice it
  #
  # i hate my life
  injector.import (hm + "/home-manager/home-manager.nix") {
    confPath = ./home2.nix;
  }
