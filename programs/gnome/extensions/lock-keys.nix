{ pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."lockkeys@vaina.lt";
  }];
}
