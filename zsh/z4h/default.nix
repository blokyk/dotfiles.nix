{ config, lib, ... }:
let
  cfg = config.programs.z8h;
in {
  imports = [
    ./keybindings.nix
    # ./fn
  ];

  options = {
    programs.z8h = {
      enable = lib.mkEnableOption "z8h, a z4h re-implementation";
    };
  };

  config = {
    programs.zsh = lib.mkIf cfg.enable {
    };
  };
}
