{ ... }:
let
  # list all files and folders that aren't 'default.nix'
  listNixFilesAndDirs = path:
    let
      # avoid importing the current file (default.nix)
      files = builtins.attrNames (removeAttrs (builtins.readDir path) [ "default.nix" ]);
    in
      map (name: path + ("/" + name)) files;
in {
  imports = listNixFilesAndDirs ./.;
}
