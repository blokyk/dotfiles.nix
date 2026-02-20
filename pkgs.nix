{ pkgs, ... }:
let
  scripts = pkgs.callValue ./scripts {};
  aliases = pkgs.callValue ./aliases.nix {};

  nix-debug = pkgs.callPackage nix-debug-src {};
  nix-debug-src = pkgs.fetchFromGitHub {
    owner = "blokyk";
    repo = "nix-debug";
    rev = "2d503b8a8321e916a2687cea7f7a4b0a4bd19339";
    hash = "sha256-5hUtUArOVU2OdSkV51S1q9cNxbTrxc5HoE3/W9Mxq5M=";
  };

  git-point = import <git-point> { inherit pkgs; };

  # androidsdk = (pkgs.androidenv.composeAndroidPackages {
  #   platformVersions = [ "35" ];
  #   systemImageTypes = [ "google_apis_playstore" ];
  #   abiVersions = [ "arm64-v8a" ];
  #   includeNDK = true;
  # }).androidsdk;
in {
  home.packages = with pkgs; [
    # a fancy alternative to cat(1)
    bat
    # # a safer, friendlier alternative to git-update-ref
    # git-point
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
    # androidsdk
    # nh # search is broken + other commands are flake-centric :(
    # nix-prefetch-github # replaced by alias
  ] ++ (builtins.attrValues scripts) ++ (builtins.attrValues aliases);
}