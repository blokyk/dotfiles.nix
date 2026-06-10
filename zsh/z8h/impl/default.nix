{ config, lib, ... }:
let
  cfg = config.programs.z8h;
in {
  imports = [
    ./autosuggestions.nix
    ./keybindings.nix
    ./base
  ];

  options = {
    programs.z8h = {
      enable = lib.mkEnableOption "z8h, a z4h re-implementation";
    };
  };
}
