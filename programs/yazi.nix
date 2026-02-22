{ pkgs, ... }:
let
  toTOML = (pkgs.formats.toml { }).generate;
in {
  xdg.configFile = {
    # don't use nerdfonts for icons and stuff
    "yazi/theme.toml".source = toTOML "theme.toml" {
      status = {
        separator_open  = "";
        separator_close = "";
      };

      icon = {
        globs = [ ];
        dirs = [ ];
        files = [ ];
        exts = [ ];
        conds = [ ];
      };
    };
  };
}