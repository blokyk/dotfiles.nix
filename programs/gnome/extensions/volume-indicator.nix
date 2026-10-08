{ pkgs, ... }: {
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeCurrentExtensions."osd-volume-number@deminder"; }
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/osd-volume-number" = {
      adapt-panel-menu = true;
      number-position = "right";
      icon-position = "left";
    };
  };
}
