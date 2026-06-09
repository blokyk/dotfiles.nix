{ config, lib, pkgs, ... }:
let
  inherit (builtins) attrValues;

  wrap = pkgs.wrapper-manager.wrap;
  mkAlias = pkgs.callPackage <self/misc/mkAlias.nix> {};
  HOME = config.home.homeDirectory;

  # wrappers REPLACE the original binary (and there's no direct way to get the original)
  wrappers = {
    # always display sizes in human formats
    # fixme: this should be `wrap`, but idk how to set a specific program to wrap
    df = mkAlias {
      name = "df";
      pkg = pkgs.coreutils;
      baseCmd = "df";
      flags = [ "--human-readable" ];

      # we don't want this to override/replace coreutils stuff
      mergeWithBasePkg = false;
    };

    # always use colors when possible
    # fixme: same as above
    ip = mkAlias {
      name = "ip";
      pkg = pkgs.iproute2;
      baseCmd = "ip";
      flags = [ "--color=auto" ];
      # don't replace distribution iproute2 stuff
      mergeWithBasePkg = false;
    };

    # nix-prefetch-github is a very niece piece of software,
    # and thus it lets us override flags later in the invocation.
    # therefore, there's no danger with wrapping it globally instead
    # of a making an alias
    nix-prefetch-github = wrap {
      basePackage = pkgs.nix-prefetch-github;
      prependFlags = [ "--nix" ];
      # mergeWithBasePkg = true;
    };

    # display richer trees
    tree = wrap {
      basePackage = pkgs.tree;
      prependFlags = [
        "-a" # print all files, including hidden ones
        "-I" ".git" # ignore .git directory
      ];
      # mergeWithBasePkg = true;
    };
  };

  # aliases simply add new names in a shell, they shouldn't have the same name as a command
  # note: doing things like this isn't really equivalent to an actual shell alias.
  #       importantly, since we get the package from nixpkgs, it won't have any wrapping
  #       from wrapper-manager; this can be a pro or a con, but it's important to remember.
  aliases = {
    # `git` with the right arguments to manage my dotfiles
    ".f" = {
      pkg = pkgs.git;
      flags = [
          "--git-dir" "${HOME}/.dotfiles"
          "--work-tree" "${HOME}"
      ];
    };

    clipcopy = {
      pkg = pkgs.xclip;
      flags = [ "-selection" "clipboard" "-in" ];
    };

    clippaste = {
      pkg = pkgs.xclip;
      flags = [ "-selection" "clipboard" "-out" ];
    };

    la = {
      pkg = pkgs.coreutils;
      baseCmd = "ls";
      flags = [ "--almost-all" ];
    };

    # just a bare alias to npins, so that you can use `lix pin`
    lix-pin = {
      pkg = pkgs.npins;
      flags = [];
    };

    ll = {
      pkg = pkgs.coreutils;
      baseCmd = "ls";
      flags = [ "-lha" ];
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
        "--file" "<nixpkgs>"
      ];
    };

    wdf = {
      pkg = pkgs.unixtools.watch;
      flags = [
        "--interval" ".5"
        (lib.getExe wrappers.df)
      ];
    };
  };

  realAliases =
    lib.mapAttrs
      (alias: attrs: mkAlias ({ name = alias; } // attrs))
      aliases;
in {
  home.packages =
    (attrValues wrappers) ++ (attrValues realAliases);
}
