{ lib, ... }:
let config = import ./default.nix; in {
  news = lib.mkForce config.config.news;
  home = {
    inherit (config.config.home) homeDirectory stateVersion username;
    activationPackage = lib.mkForce config.config.home.activationPackage;
  };
}
