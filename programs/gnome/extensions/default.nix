{ lib, ... }: {
  imports = [(
    lib.modules.importApply <self/misc/importNixFilesAndDirs.nix> ./.
  )];

  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [ "ding@rastersoft.com" ];
    };
  };
}
