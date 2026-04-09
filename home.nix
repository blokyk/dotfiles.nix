{ lib, ... }:
let config = import ./default.nix; in {
  home = {
    inherit (config.config.home) homeDirectory stateVersion username;
    activationPackage = lib.mkForce config.config.home.activationPackage;
  };
}
