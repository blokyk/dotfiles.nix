{ config, lib, ... }:
let
  files = import ./list.nix;
  cfg = config.programs.z3h.functions;

  # constructs boolean enable options for each function in `files`
  opts = lib.mapAttrs
    (fn: _: lib.mkEnableOption "autoloading the ${fn} function")
    files;

  # given { z4h-foo = true; }, returns { z4h-foo = readFile ./z4h-foo; }
  cfgs = lib.mapAttrs
    (fn: val: lib.mkIf val files.${fn})
    cfg;
in {
  # creates options:
  # programs.z8h.functions.z4h-foo = mkEnable ...
  #
  # which, if z4h-foo is set to true, will result in the config:
  # programs.zsh.siteFunctions.z4h-foo = readFile ./z4h-foo;

  options.programs.z8h.functions = opts;
  config.programs.zsh.siteFunctions = cfgs;
}
