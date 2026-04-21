path:
{ lib, ... }:
let
  unfilteredEntries = builtins.readDir path;

  nixyEntries = lib.filterAttrs (
    name: type:
      if type == "directory" then
        builtins.pathExists (path + (("/" + name) + "/default.nix"))
      else
        # include all nix files *except* default.nix
        lib.hasSuffix ".nix" name && name != "default.nix"
  ) unfilteredEntries;

  pathsToImport = lib.mapAttrsToList (name: _: path + ("/" + name)) nixyEntries;
in {
  imports = pathsToImport;
}
