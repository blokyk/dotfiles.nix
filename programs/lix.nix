{ config, lib, pkgs, ... }: {
  nix.package =  pkgs.lixPackageSets.git.lix;
  nixpkgs.overlays = [
    (final: prev: {
      lixPackageSets = prev.lixPackageSets.extend (finalSet: prevSet: {
        git = (prevSet.makeLixScope {
          attrName = "git";

          lix-args = rec {
            version = "2.96.0-pre-20260701_${builtins.substring 0 12 src.rev}";

            src = pkgs.fetchFromGitea {
              domain = "git.lix.systems";
              owner = "lix-project";
              repo = "lix";
              rev = "cf1e565a0a955bc40a66da82e6cdae481371b8cd";
              hash = "sha256-PI+pn+CYqcKxiZq0gVxGmnBKD+UA1VMRQNr9vyAK4/A=";
            };

            cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
              name = "lix-${version}";
              inherit src;
              hash = "sha256-8Z4bV7K4f3lAdKu0h4DYgWHKJ9DmRArHZAKhHpUbkuY=";
            };
          };
        }).overrideScope (finalScope: prevScope: {
          lix = prevScope.lix.overrideAttrs { doCheck = false; doInstallCheck = false; };
        });
      });

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

      inherit (final.lixPackageSets.git)
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
    })
  ];
}
