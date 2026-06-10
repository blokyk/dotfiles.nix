{ config, lib, ... }:
let
  inherit (lib) mkOptionDefault;
  cfg = config.programs.z8h;

  baseKeyMap = {
    "<Control>"   = "^";
    "<Alt>"       = "^[";
    Tab       = "^I";
    Space     = " ";
    Enter     = "^M";
    Escape    = "^[";
    Up        = "^[[A";
    Down      = "^[[B";
    Right     = "^[[C";
    Left      = "^[[D";
    Home      = "^[[H";
    End       = "^[[F";
    Insert    = "^[[2~";
    Delete    = "^[[3~";
    PageUp    = "^[[5~";
    PageDown  = "^[[6~";
    Backspace = "^?";
  };

  # there's a few non unique translations:
  #   - ^_
  #     - Ctrl+/
  #     - Ctrl+_
  #   - ^?
  #     - Backspace
  #     - Shift+Backspace
  #     - Ctrl+Shift+Backspace
  #     - Ctrl+Alt+Shift+Backspace
  #   - ^[^H
  #     - Alt+Shift+Backspace
  #     - Ctrl+Alt+Backspace
  combinationReverseMap = {
    "^[[Z" = [ "<Shift>" "Tab" ];
    "^[[1;2A" = [ "<Shift>" "Up" ];
    "^[[1;2B" = [ "<Shift>" "Down" ];
    "^[[1;2C" = [ "<Shift>" "Right" ];
    "^[[1;2D" = [ "<Shift>" "Left" ];
    "^[[1;2H" = [ "<Shift>" "Home" ];
    "^[[1;2F" = [ "<Shift>" "End" ];
    "^[[2;2~" = [ "<Shift>" "Insert" ];
    "^[[3;2~" = [ "<Shift>" "Delete" ];
    "^[[5;2~" = [ "<Shift>" "PageUp" ];
    "^[[6;2~" = [ "<Shift>" "PageDown" ];

    "^[[1;3A" = [ "<Alt>" "Up" ];
    "^[[1;3B" = [ "<Alt>" "Down" ];
    "^[[1;3C" = [ "<Alt>" "Right" ];
    "^[[1;3D" = [ "<Alt>" "Left" ];
    "^[[1;3H" = [ "<Alt>" "Home" ];
    "^[[1;3F" = [ "<Alt>" "End" ];
    "^[[2;3~" = [ "<Alt>" "Insert" ];
    "^[[3;3~" = [ "<Alt>" "Delete" ];
    "^[[5;3~" = [ "<Alt>" "PageUp" ];
    "^[[6;3~" = [ "<Alt>" "PageDown" ];

    "^[[1;4A" = [ "<Alt>" "<Shift>" "Up" ];
    "^[[1;4B" = [ "<Alt>" "<Shift>" "Down" ];
    "^[[1;4C" = [ "<Alt>" "<Shift>" "Right" ];
    "^[[1;4D" = [ "<Alt>" "<Shift>" "Left" ];
    "^[[1;4H" = [ "<Alt>" "<Shift>" "Home" ];
    "^[[1;4F" = [ "<Alt>" "<Shift>" "End" ];
    "^[[2;4~" = [ "<Alt>" "<Shift>" "Insert" ];
    "^[[3;4~" = [ "<Alt>" "<Shift>" "Delete" ];
    "^[[5;4~" = [ "<Alt>" "<Shift>" "PageUp" ];
    "^[[6;4~" = [ "<Alt>" "<Shift>" "PageDown" ];

    "^[[1;5A" = [ "<Ctrl>" "Up" ];
    "^[[1;5B" = [ "<Ctrl>" "Down" ];
    "^[[1;5C" = [ "<Ctrl>" "Right" ];
    "^[[1;5D" = [ "<Ctrl>" "Left" ];
    "^[[1;5H" = [ "<Ctrl>" "Home" ];
    "^[[1;5F" = [ "<Ctrl>" "End" ];
    "^[[2;5~" = [ "<Ctrl>" "Insert" ];
    "^[[3;5~" = [ "<Ctrl>" "Delete" ];
    "^[[5;5~" = [ "<Ctrl>" "PageUp" ];
    "^[[6;5~" = [ "<Ctrl>" "PageDown" ];
    "^H"      = [ "<Ctrl>" "Backspace" ];

    "^[[1;6A" = [ "<Ctrl>" "<Shift>" "Up" ];
    "^[[1;6B" = [ "<Ctrl>" "<Shift>" "Down" ];
    "^[[1;6C" = [ "<Ctrl>" "<Shift>" "Right" ];
    "^[[1;6D" = [ "<Ctrl>" "<Shift>" "Left" ];
    "^[[1;6H" = [ "<Ctrl>" "<Shift>" "Home" ];
    "^[[1;6F" = [ "<Ctrl>" "<Shift>" "End" ];
    "^[[2;6~" = [ "<Ctrl>" "<Shift>" "Insert" ];
    "^[[3;6~" = [ "<Ctrl>" "<Shift>" "Delete" ];
    "^[[5;6~" = [ "<Ctrl>" "<Shift>" "PageUp" ];
    "^[[6;6~" = [ "<Ctrl>" "<Shift>" "PageDown" ];

    "^[[1;7A" = [ "<Ctrl>" "<Alt>" "Up" ];
    "^[[1;7B" = [ "<Ctrl>" "<Alt>" "Down" ];
    "^[[1;7C" = [ "<Ctrl>" "<Alt>" "Right" ];
    "^[[1;7D" = [ "<Ctrl>" "<Alt>" "Left" ];
    "^[[1;7H" = [ "<Ctrl>" "<Alt>" "Home" ];
    "^[[1;7F" = [ "<Ctrl>" "<Alt>" "End" ];
    "^[[2;7~" = [ "<Ctrl>" "<Alt>" "Insert" ];
    "^[[3;7~" = [ "<Ctrl>" "<Alt>" "Delete" ];
    "^[[5;7~" = [ "<Ctrl>" "<Alt>" "PageUp" ];
    "^[[6;7~" = [ "<Ctrl>" "<Alt>" "PageDown" ];
  };

  mapKeyCombinations = str: str; # fixme: fixmeeeeeeeeeeeeeeeeeeeeeeeeeeeee
in {
  imports = [
    ./fn

    (lib.modules.importApply <zoeee/hm-modules/mk-keybindings> {
      multiKeybindings = false;
      optPath = [ "programs" "z8h" "keybindings" ];
      prefixPath = [ "programs" "zsh" "initBlocks" "keybindings" ];
      setter = action: keybind: ''
        bindkey ${mapKeyCombinations keybind} ${action}
      '';
      keyMapper = key: baseKeyMap.${key};
    })
  ];

  config = lib.mkMerge [
    {
      assertions = lib.mapAttrsToList (action: binding: {
        assertion = config.programs.zsh.siteFunctions ? action;
        message = "programs.z8h.keybindings: action '${action}' is not a known function from programs.zsh.siteFunctions";
      }) cfg.keybindings;
    }
  ];
}
