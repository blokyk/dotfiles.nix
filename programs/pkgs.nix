{ pkgs, ... }:
let
  nix-debug = pkgs.callPackage nix-debug-src {};
  nix-debug-src = pkgs.fetchFromGitHub {
    owner = "blokyk";
    repo = "nix-debug";
    rev = "8f839960a08accc27e179978986dec558ea176fb";
    hash = "sha256-p8r2xRUZZTVM/A5lv68fxpy/w9uW5CWReMniezWkR3o=";
  };
in {
  home.packages = with pkgs; [
    # fancy alternative to cat(1)
    bat
    # du, but more interactive
    dust
    # simple, fast and user-friendly alternative to find
    fd
    # general-purpose command-line fuzzy finder
    fzf
    # command-line hex viewer
    hexyl
    # command-line benchmarking tool
    hyperfine
    # kindle comic converter
    kcc
    # pretty diff between two derivations
    lix-diff
    # simple alternative to strace
    lurk
    # language server for nix
    nixd
    # official nix formatter
    nixfmt
    # dev tool for nixpkgs PR
    nixpkgs-review
    # wrapper around nix-shell for debugging derivations
    nix-debug
    # prettify and summarize nix build output
    nix-output-monitor
    # analyze disk usage of profiles, gc roots, or even specific derivations
    nix-sweep
    # explore dependency trees of derivations
    nix-tree
    # recursively searches directories for a pattern
    ripgrep
    # manage systemd services through a TUI
    systemd-manager-tui
    # 'tldr.sh' client written in rust
    tlrc
    # quick code line counter
    tokei
    # markup-based typesetting
    typst
    # terminal file explorer
    yazi
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
