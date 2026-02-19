{
  hm-config,
  pkgs,
  lib,

  wrapper-manager,
  ...
}:
let
  wrap = wrapper-manager.wrap;
  mkAlias = pkgs.callPackage ./misc/mkAlias.nix {};
  HOME = hm-config.home.homeDirectory;

  # wrappers REPLACE the original binary (and there's no direct way to get the original)
  wrappers = {
    # nix-prefetch-github is a very niece piece of software,
    # and thus it lets us override flags later in the invocation.
    # therefore, there's no danger with wrapping it globally instead
    # of a making an alias
    nix-prefetch-github = wrap {
      basePackage = pkgs.nix-prefetch-github;
      prependFlags = [ "--nix" ];
    };
  };

  # aliases simply add new names in a shell, they shouldn't have the same name as a command
  aliases = {
    # `git` with the right arguments to manage my dotfiles
    ".f" = {
      pkg = pkgs.git;
      flags = [
          "--git-dir" "${HOME}/.dotfiles"
          "--work-tree" "${HOME}"
      ];
    };

    lspci-tree = {
      pkg = pkgs.pciutils;
      flags = [
        "-t" # tree
        "-v" # verbose (level 1)
      ];
    };

    # nix repl -f <nixpkgs>
    nrp = {
      pkg = pkgs.nix-impl-cli;
      baseCmd = "nix";
      flags = [
        "repl"
        "-f" "<nixpkgs>"
      ];
    };
  };

  realAliases =
    lib.mapAttrs
      (alias: attrs: mkAlias ({ name = alias; } // attrs))
      aliases;
in
  wrappers // realAliases