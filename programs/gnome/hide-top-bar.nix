{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeExtensions.hide-top-bar;
  }];

  dconf.settings = {
    "org/gnome/shell/extensions/hidetopbar" = {
      # only hide top bar when *active* window covers it (e.g. is fullscreen)
      enable-active-window = true;

      # show top bar when the mouse comes close to it
      mouse-sensitive = true;
    };
  };
}
