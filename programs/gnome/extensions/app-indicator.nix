{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."ubuntu-appindicators@ubuntu.com";
  }];
}
