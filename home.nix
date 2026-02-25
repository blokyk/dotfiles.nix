{ config, ... }:
let
in {
  home.username = "blokyk";
  home.homeDirectory = "/home/blokyk";
  targets.genericLinux.enable = true; # non-NixOS system

  imports = [
    ./env.nix

    ./programs
    ./scripts
    ./zsh
  ];

  nixpkgs.overlays = [(
    final: prev: {
      # a helper to use `callPackage` on non-derivation values (attrset or not)
      # that shouldn't have the 'override*' attrs on them
      callValue = file: overrides:
        let raw = final.callPackage file overrides; in
        if (builtins.isAttrs raw)
          then removeAttrs raw [ "override" "overrideAttrs" "overrideDerivation" ]
          else raw;

      wrapper-manager =
        (final.callPackage ./misc/wrapper-manager.nix {}) // {
          wrap = final.wrapper-manager.lib.wrapWith final;
        };
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
