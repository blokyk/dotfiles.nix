{ config, ... }:
let
in {
  home.username = "blokyk";
  home.homeDirectory = "/home/blokyk";
  targets.genericLinux.enable = true; # non-NixOS system

  imports = [
    ./env.nix
    ./pkgs.nix

    ./programs
  ];

  nixpkgs.overlays = [(
    final: prev: {
      # a helper to use `callPackage` on non-attrset values
      # or on sets that shouldn't have the override* attributes
      callValue = file: pkgs:
        removeAttrs
          (final.callPackage file pkgs)
          [ "override" "overrideAttrs" "overrideDerivation" ];
      # make home-manager config easily accessible with callPackage/callValue
      hm-config = config;
      # create a virtual package for the nix implementation we use so
      # that our scripts/aliases don't have to worry about choosing it
      nix-impl-cli = final.lixPackageSets.latest.lix;
      wrapper-manager.wrap = (final.callPackage ./misc/wrapper-manager.nix {}).lib.wrapWith final;
    }
  )];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = "..";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
