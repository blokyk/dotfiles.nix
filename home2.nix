{ config, hostname, lib, pkgs, ... }: {
  # inject 'zpkgs' arg into other modules to easily get zoeee/pkgs
  _module.args.zpkgs = pkgs.callPackage <zoeee/pkgs> {};

  # select username based on host
  home.username = {
    LOQ-15AHP9 = "blokyk";
    dragonnier = "courvoie";
    aa = "courvoie";
  }.${hostname};

  home.homeDirectory = "/home/${config.home.username}";
  targets.ubuntu = {
    enable = true;
    version = "25.04";
  };

  imports = [
    ./fonts.nix
    ./env.nix
    ./aliases.nix
    ./locale.nix
    ./theme.nix
    ./misc/targets-ubuntu.nix

    (lib.setDefaultModuleLocation <zoeee/hm-modules>.outPath (import <zoeee/hm-modules>))

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

      fast-nix-gc = pkgs.callPackage <fast-nix-gc> {};
      nix-diff-rs = pkgs.callPackage <nix-diff-rs/package.nix> {};

      # allow packages to be based on the home-manager config
      hm-config = config;

      nix-debug = pkgs.callPackage <nix-debug> {};

      mkAlias = pkgs.callPackage <self/misc/mkAlias.nix> {};

      wrapper-manager =
        (import <wrapper-manager>) // {
          wrap = final.wrapper-manager.lib.wrapWith final;
        };

      zpkgs = config._module.args.zpkgs;

      inherit (import <nixpkgs-gnome-48> {}) gnome48Extensions;

      gnomeCurrentExtensions = final.${"gnome${toString config.targets.genericLinux.extraInfo.gnome.version}Extensions"};
    }
  )];

  programs.home-manager.diff-on-activation = {
    enable = true;
    ask-for-confirmation = true;
  };

  home.activation = {
    printGenerations = lib.hm.dag.entryBefore ["reportGenDiff" "writeBoundary"] ''
      echo -e "\e[31m- /nix/store/\e[1m$(echo -n "$oldGenPath" | cut -c 12-43)\e[22m-home-manager-generation\e[0m"
      echo -e "\e[32m+ /nix/store/\e[1m$(echo -n "$newGenPath" | cut -c 12-43)\e[22m-home-manager-generation\e[0m"
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
