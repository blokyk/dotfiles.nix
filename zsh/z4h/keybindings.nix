{ config, lib, ... }:
let
  cfg = config.programs.z8h;

  fn = import ./fn/list.nix;
in {
  imports = [(
    lib.modules.importApply <zoeee/hm-modules/mk-keybindings> {
      optPath = [ "programs" "z3h" "keybindings" ];
      prefixPath = [ "programs" "zsh" "initBlocks" "keybindings" ];
      setter = action: keybind: ''
        bindkey ${action}
      '';
    }
  )];

  options = {
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
