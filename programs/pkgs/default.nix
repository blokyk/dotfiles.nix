{ pkgs, zpkgs, ... }: {
  imports = [
    ./apps.nix
    ./dev.nix
    ./essential.nix
  ];

  # todo: ryubing
  # todo: vineflower
  # todo: waver
  home.packages = with pkgs; [
    # du, but more interactive
    dust
    # analyze disk usage of profiles, gc roots, or even specific derivations
    nix-sweep
    # a modern manual viewer
    zpkgs.qman
    # manage systemd services through a TUI
    systemd-manager-tui
    # markup-based typesetting
    typst
  ];

  # todo: add git-point (doesn't work currently because of weird packaging)
  #   git-point = import <git-point> { inherit pkgs; };

  # removed packages:
  #   androidsdk
  #   nh # search is broken + other commands are flake-centric :(
  #   nix-prefetch-github # replaced by alias
  #
  #   androidsdk = (pkgs.androidenv.composeAndroidPackages {
  #     platformVersions = [ "35" ];
  #     systemImageTypes = [ "google_apis_playstore" ];
  #     abiVersions = [ "arm64-v8a" ];
  #     includeNDK = true;
  #   }).androidsdk;
}
