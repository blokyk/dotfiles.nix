{ pkgs, ... }: {
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeCurrentExtensions."battery-indicator-icon@Deminder"; }
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/battery-indicator-icon" = {
      status-style = "circle";
    };
  };
}
