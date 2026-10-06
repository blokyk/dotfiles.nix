{ lib, pkgs, ... }: {
  imports = [(
    lib.modules.importApply <self/misc/importNixFilesAndDirs.nix> ./.
  )];

  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [ "ding@rastersoft.com" ];
    };
  };

  programs.gnome-shell.extensions = let exts = pkgs.gnomeCurrentExtensions; in [
    { package = exts."applications-overview-tooltip@RaphaelRochet"; }
    { package = exts."alt-tab-scroll-workaround@lucasresck.github.io"; }
    { package = exts."lockkeys@vaina.lt"; }
    { package = exts."steal-my-focus-window@steal-my-focus-window"; }
    { package = exts."ubuntu-appindicators@ubuntu.com"; }
  ];
}
