{ config, lib, ... }:
let
  firefox = config.programs.firefox.package;
in {
  imports = [
    ./extensions
    ./keybindings.nix
  ];

  programs.gnome-shell.enable = true;

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "${lib.getName (firefox.desktopItem or firefox)}.desktop"
        "com.gexperts.Tilix.desktop"
      ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/desktop/interface" = {
      # disable that FUCKING middle click paste
      gtk-enable-primary-paste = false;
    };
  };
}
