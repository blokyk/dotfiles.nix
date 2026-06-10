{ config, lib, ... }:
let
  cfg = config.programs.zsh.z8h;
in {
  imports = [
    ./keybindings.nix
  ];

  options = {
    programs.zsh.z8h = {
      enable = lib.mkEnableOption "z8h, a z4h re-implementation";
    };
  };

  config = {
    programs.zsh = lib.mkIf cfg.enable {

    };
  };
}
