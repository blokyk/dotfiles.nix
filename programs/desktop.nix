{ config, lib, pkgs, ... }:
let
  firefox = config.programs.firefox.package;
in {
  # favorite apps don't have a standard way to be set
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "${lib.getName firefox.desktopItem}"
        "com.gexperts.Tilix.desktop"
      ];
    };
  };

  xdg.desktopEntries = {
    xcolor = {
      name = "XColor";
      genericName = "Color picker";
      comment = "Pick a color from any app on screen";
      icon = "xcolor"; # already in the theme, so no need for an actual icon :)
      categories = [
        "Utility"
        "ImageProcessing"
      ];

      exec = "bash -c \"sleep 1; ${lib.getExe pkgs.xcolor} --selection clipboard\"";
      terminal = false;

      actions = {
        "rgb" = {
          name = "Pick in RGB";
          exec = "bash -c \"sleep 1; ${lib.getExe pkgs.xcolor} --selection clipboard --format rgb\"";
        };
      };
    };
  };
}
