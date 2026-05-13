{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."steal-my-focus-window@steal-my-focus-window";
  }];
}
