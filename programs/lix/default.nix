{ config, pkgs, ... }: {
  nix.package =  pkgs.lixPackageSets.custom.lix;
  nixpkgs.overlays = [
    (final: prev: {
      lixPackageSets = prev.lixPackageSets.extend (_: _: {
        # since we using *prev*.callPackage, we implicitly
        # pass the _previous_ `lixPackageSets` value here
        custom = prev.callPackage ./scope.nix { };
      });

      # create a virtual package for the nix implementation we use so
      # that our scripts/aliases don't have to worry about choosing it
      nix-impl-cli = config.nix.package;

      # we can't use lixPackageSets's nixpkgs-review because of https://zulip.lix.systems/#narrow/channel/11-Support/topic/infinite.20recursion.20in.20.22Advanced.20change.22.20with.20nixpkgs-25.2E11.3F
      nixpkgs-review = prev.nixpkgs-review.override {
        nix = prev.lix;
        inherit (final) nix-eval-jobs; # use non-lix one because it doesn't support --apply
      };
      nixpkgs-reviewFull = prev.nixpkgs-reviewFull.override {
        inherit (final) nixpkgs-review;
      };

      inherit (final.lixPackageSets.custom)
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
    })
  ];
}
