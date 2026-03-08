{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      figlet = prev.figlet.overrideAttrs (final: prev: {
        contributed = pkgs.symlinkJoin {
          name = "fonts";
          paths = [
            prev.contributed
            <figlet-fonts>
          ];
        };
      });
    })
  ];
}
