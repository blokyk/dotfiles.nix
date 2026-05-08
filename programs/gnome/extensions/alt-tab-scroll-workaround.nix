{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."alt-tab-scroll-workaround@lucasresck.github.io";
  }];
}
