{ config, lib, pkgs, ... }: {
  nix.package =  pkgs.lixPackageSets.latest.lix;
  nixpkgs.overlays = [
    (final: prev: {
      # create a virtual package for the nix implementation we use so
      # that our scripts/aliases don't have to worry about choosing it
      nix-impl-cli = config.nix.package;

      # we can't use lixPackageSets's nixpkgs-review because of https://zulip.lix.systems/#narrow/channel/11-Support/topic/infinite.20recursion.20in.20.22Advanced.20change.22.20with.20nixpkgs-25.2E11.3F
      nixpkgs-review = prev.nixpkgs-review.override {
        nix = prev.lix;
        inherit (prev) nix-eval-jobs; # use non-lix one because it doesn't support --apply
      };
      nixpkgs-reviewFull = prev.nixpkgs-reviewFull.override {
        inherit (final) nixpkgs-review;
      };

      inherit (final.lixPackageSets.latest)
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;

      # the upstream repo already includes packaging for it in `default.nix`,
      # but it unfortunately hides a few packaging details in the flake :(
      nix-output-monitor =
        let
          hlib = final.haskell.lib.compose;
          base-nom = final.haskellPackages.callPackage (final.fetchFromForgejo {
            domain = "code.maralorn.de";
            owner = "maralorn";
            repo = "nix-output-monitor";
            rev = "3e6592850fdda133135ccd759bbf8bec5b7b412e";
            sha256 = "sha256-KlJnug3cpSb5jUIbsg95mX1w+tI5bAwBUJb4nJxCjxQ=";
          }) {};
        in
          lib.pipe base-nom [
            pkgs.haskellPackages.buildFromCabalSdist
            hlib.justStaticExecutables

            (hlib.overrideCabal {
              # the original flake packaging does some fiddling around to only run
              # _some_ of the tests in the test suite, but i don't care enough for
              # that here, so just disable everything
              doCheck = false;

              # get correct shell completions
              buildTools = [ final.installShellFiles ];
              postInstall = ''
                ln -s nom "$out/bin/nom-build"
                ln -s nom "$out/bin/nom-shell"
                chmod a+x $out/bin/nom-shell
                installShellCompletion completions/*
              '';
            })
          ];
    })
  ];
}
