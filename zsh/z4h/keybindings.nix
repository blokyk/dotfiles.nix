{ config, lib, ... }:
let
  cfg = config.programs.z3h;
in {
  options = {
    programs.z3h.keybindings = {
      
    };
  };

  config = {
    programs.zsh = lib.mkIf cfg.enable {
      initBlocks = {
        keybindings = ''
          bindkey
        '';
      };
    };
  };
}
