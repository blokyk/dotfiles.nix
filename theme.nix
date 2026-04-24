{ config, pkgs, ... }:
let
  whitesur-theme = pkgs.whitesur-gtk-theme.override {

  };

  whitesur-icons = pkgs.whitesur-icon-theme.override {

  };
in {
  imports = [ <self/misc/gnome-shell-impl.nix>.outPath ];

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

  gtk.cursorTheme = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
  };

  programs.gnome-shell.theme = {
    name = "WhiteSur-Dark";
    package = whitesur-theme;
  };

  home.pointerCursor = {
    enable = true;
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
  };
}
