{ config, lib, pkgs, ... }:
let
  cfg = config.home.wrappers;
in {
  options = {
    home.wrappers = lib.mkOption {
      description = ''
        A set of wrappers/aliases to add to {option}`home.packages`.
        In the most cases, this should be preferred over {option}`home.shellAliases` for single-program aliases.
        Exceptions are when:
          - non-nixified programs depend on the default (non-aliased) behavior
          - the alias has the same name as the base program, and the latter isn't managed with nix (e.g. from a non-nixos distro)
      '';
      example = {
        # todo
      };
      type = lib.types.submodule {
        options = {
          
        };
      };
    };
  };
}
