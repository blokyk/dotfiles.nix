{ pkgs, ... }:
let
  wm-src = pkgs.fetchFromGitHub {
    owner = "viperML";
    repo = "wrapper-manager";
    rev = "801dd9c876fcada046af45543e8c7e0bbccf20ea";
    hash = "sha256-OGXsTE5jWhGiFfK6OwMvjksrYSobsIFUSUzKsexCDxY=";
  };
in import wm-src