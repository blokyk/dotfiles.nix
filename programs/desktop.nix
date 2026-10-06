{ config, lib,... }:
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
  };
}
