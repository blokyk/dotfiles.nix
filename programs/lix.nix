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

      # we need to use an older version of nix-output-monitor, because
      # since 2.1.7 it adapts to cppnix's slightly breaking json format,
      # which lix doesn't use
      nix-output-monitor = prev.nix-output-monitor.overrideAttrs {
        version = "2.1.6";
        src = pkgs.fetchzip {
          url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/v2.1.6.tar.gz";
          sha256 = "sha256-YfxFcGD9U7RzctnTRUQX1Nsz2EtiDIUGpz2nTo0OSWw=";
        };
      };
    })
  ];
}
