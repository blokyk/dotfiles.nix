{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeExtensions.hide-top-bar;
  }];

  dconf.settings = {
    "org/gnome/shell/extensions/hidetopbar" = {
      # always hide the top bar, even when the active window doesn't cover it
      enable-active-window = false;

      # show top bar when the mouse comes close to it
      mouse-sensitive = true;
    };
  };
}
