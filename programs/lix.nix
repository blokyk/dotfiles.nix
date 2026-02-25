{ pkgs, config, ... }: {
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
    })
  ];
}
