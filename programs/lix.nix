{ config, lib, pkgs, ... }: {
  nix.package =  pkgs.lixPackageSets.latest.lix;
  nixpkgs.overlays = [
    (final: prev: {
      # create a virtual package for the nix implementation we use so
      # that our scripts/aliases don't have to worry about choosing it
      nix-impl-cli = config.nix.package;

      inherit (final.lixPackageSets.latest)
        # nixpkgs-review # fixme: lix bug :/ https://zulip.lix.systems/#narrow/channel/11-Support/topic/infinite.20recursion.20in.20.22Advanced.20change.22.20with.20nixpkgs-25.2E11.3F
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
            rev = "388f56120f655a9cf4512e697b2c2afa06fe7434";
            sha256 = "sha256-3N+PVFpsnBtQ11Vk9OKm1q9dE0d5fxGsEDyfwoxpYaE=";
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
