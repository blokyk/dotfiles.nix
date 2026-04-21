{ lib, ... }: {
  imports = [(
    lib.modules.importApply <self/misc/importNixFilesAndDirs.nix> ./.
  )];
}
