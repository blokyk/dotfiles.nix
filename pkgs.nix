{ pkgs, ... }:
let
  scripts = pkgs.callValue ./scripts {};
  aliases = pkgs.callValue ./aliases.nix {};

  nix-debug = pkgs.callPackage nix-debug-src {};
  nix-debug-src = pkgs.fetchFromGitHub {
    owner = "blokyk";
    repo = "nix-debug";
    rev = "8f839960a08accc27e179978986dec558ea176fb";
    hash = "sha256-p8r2xRUZZTVM/A5lv68fxpy/w9uW5CWReMniezWkR3o=";
  };
in {
  home.packages = with pkgs; [
    # a fancy alternative to cat(1)
    bat
    # a colorful diff viewer
    delta
    # a general-purpose command-line fuzzy finder
    fzf
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
    # a wrapper around nix-shell for debugging derivations
    nix-debug
    # prettify and summarize nix build output
    nix-output-monitor
    # analyze disk usage of profiles, gc roots, or even specific derivations
    nix-sweep
    # explore dependency trees of derivations
    nix-tree
  ] ++ (builtins.attrValues scripts) ++ (builtins.attrValues aliases);

  # removed packages:
  #   androidsdk
  #   git-point # a safer, friendlier alternative to git-update-ref
  #   nh # search is broken + other commands are flake-centric :(
  #   nix-prefetch-github # replaced by alias
  #
  #   androidsdk = (pkgs.androidenv.composeAndroidPackages {
  #     platformVersions = [ "35" ];
  #     systemImageTypes = [ "google_apis_playstore" ];
  #     abiVersions = [ "arm64-v8a" ];
  #     includeNDK = true;
  #   }).androidsdk;

  # todo: add git-point (doesn't work currently because of weird packaging)
  #   git-point = import <git-point> { inherit pkgs; };
}