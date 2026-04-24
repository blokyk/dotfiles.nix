{ config, pkgs, ... }:
let
in {
  home.username = "courvoie";
  home.homeDirectory = "/home/${config.home.username}";
  targets.ubuntu = {
    enable = true;
    version = "24.04";
  };

  # inject 'zpkgs' arg into other modules to easily get zoeee/pkgs
  _module.args.zpkgs = pkgs.callPackage <zoeee/pkgs> {};
  _module.args.pins  = <__pins>;

  imports = [
    ./env.nix
    ./aliases.nix
    ./locale.nix
    ./theme.nix
    ./misc/targets-ubuntu.nix

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

      # allow packages to be based on the home-manager config
      hm-config = config;

      nix-debug = pkgs.callPackage <nix-debug> {};

      wrapper-manager =
        (import <wrapper-manager>) // {
          wrap = final.wrapper-manager.lib.wrapWith final;
        };

      zpkgs = config._module.args.zpkgs;

      gnomeCurrentExtensions = prev.${"gnome${toString config.targets.genericLinux.extraInfo.gnome.version}Extensions"};
    }
  )];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = "..";
  };

  programs.home-manager.report-changes = {
    enable = true;
    askForConfirmation = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
