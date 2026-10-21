{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."advanced-alt-tab@G-dH.github.com";
  }];

  dconf.settings = {
    "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
        # todo: migrate settings
    };
  };
}
