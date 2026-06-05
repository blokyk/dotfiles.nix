{ config, pkgs, ... }:
let
  whitesur-theme = pkgs.whitesur-gtk-theme.override {

  };

  whitesur-icons = pkgs.whitesur-icon-theme.override {

  };
in {
  programs.gnome-shell.theme = {
    name = "WhiteSur-Dark";
    package = whitesur-theme;
  };

  gtk.enable = true;

  gtk.gtk4.theme = config.gtk.theme;
  gtk.theme = {
    name = "WhiteSur-Dark";
    package = whitesur-theme;
  };

  gtk.iconTheme = {
    name = "WhiteSur-dark";
    package = whitesur-icons;
  };

  # gtk.cursorTheme = {
  #   name = "capitaine-cursors-lo";
  #   package = pkgs.capitaine-cursors;
  # };

  # home.pointerCursor = {
  #   enable = true;
  #   name = "capitaine-cursors-lo";
  #   package = pkgs.capitaine-cursors;
  # };
}
