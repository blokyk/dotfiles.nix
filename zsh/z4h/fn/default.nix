{ config, lib, ... }:
let
  cfg = config.programs.z3h;
  files = lib.filter
    # don't import files that start with '-' (nor default.nix (obviously))
    (f: !lib.hasPrefix "-" f && f != "default.nix")
    (lib.attrNames (lib.readDir ./.));
in {
  programs.zsh.siteFunctions = lib.mkIf cfg.enable (
    lib.genAttrs
      files
      (f: lib.readFile (./. + ("/" + f)))
  );
}
