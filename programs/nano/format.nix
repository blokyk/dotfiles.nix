{ lib, ... }:
let
  inherit (lib) concatMapAttrsStringSep isBool;
in
{
  generate =
    {
      # attr names are setting names, values are either a boolean (indicating
      # whether it should be enabled or not) or a string/value (which will be
      # pasted verbatim after `set $settingName`)
      # eg: { autoindent = false; tabsize = 4; }
      #  -> unset autoindent; set tabsize 4;
      settings ? { },

      # colors to use for the different parts of nano's UI.
      # eg: { title = { fg = "blue"; bg = "red"; }; }
      #  -> set titlecolor red,blue
      theme ? { },

      # attr names are menu names, values are attr sets mapping key combinations
      # like ^C (ctrl+c) or M-H (alt+h) to commands like `comment` and `help`.
      # setting a binding to `false` instead of a string command will unbind that
      # key combination for that menu.
      # eg: { main."^C" = "comment"; all."M-H" = "help"; help."^F" = false; }
      #  -> bind ^C comment main; bind M-H help all; unbind ^F help;
      keybindings ? { },
    }:
    let
      settingStr =
        concatMapAttrsStringSep "\n" (
          name: value:
            if (isBool value) then
              if value
                then "set ${name}"
                else "unset ${name}"
            else
              "set ${name} ${toString value}"
        ) settings;

      themeStr =
        concatMapAttrsStringSep "\n" (
          uiPart: { fg ? "", bg ? "", }:
            # there's no bg color, we MUST NOT have a trailing comma. sad :(
            if (bg == "") then
              "set ${uiPart}color ${fg}"
            else
              "set ${uiPart}color ${fg},${bg}"
        ) theme;

      bindingsStr =
        let
          mapMenuBindings = menuName: bindings:
            concatMapAttrsStringSep "\n" (
              key: commandOrFalse:
                if (commandOrFalse == false)
                  then "unbind ${key} ${menuName}"
                  else "bind  ${key} ${commandOrFalse} ${menuName}"
            ) bindings;
        in
          concatMapAttrsStringSep "\n" mapMenuBindings keybindings;
    in
      settingStr + "\n\n" + themeStr + "\n\n" + bindingsStr;
}
