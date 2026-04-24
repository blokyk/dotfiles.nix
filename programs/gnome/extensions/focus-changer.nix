{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."focus-changer@heartmire";
  }];

  dconf.settings = {
    "org/gnome/shell/extensions/focus-changer" = {
      # already used for multi-select in text editors
      # focus-down = [ "<Shift><Alt>Down" ];
      # focus-up = [ "<Shift><Alt>Up" ];
      focus-left = [ "<Shift><Alt>Left" ];
      focus-right = [ "<Shift><Alt>Right" ];
    };
  };
}
