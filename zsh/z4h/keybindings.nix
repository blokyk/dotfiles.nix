{ config, lib, ... }:
let
  cfg = config.programs.z8h;

  fn = import ./fn/list.nix;
in {
  options = {
    programs.z8h.keybindings = {
      
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
