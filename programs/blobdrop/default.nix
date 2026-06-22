# a CLI utility to drag and drop files directly from the terminal.
{ pkgs, ... }: {
  nixpkgs.overlays = [(
    final: prev: {
      blobdrop = prev.blobdrop.overrideAttrs (prev: {
        # artisanal patch made from a bunch of hand-made cherry picks,
        # because upstream is a nightmare now cause the author is using
        # a very weird packaging method ++ their own package, which makes
        # it a nightmare to actually override nixpkgs or any input drvs
        patches = (prev.patches or []) ++ [ ./multi-select.patch ];
      });
    }
  )];

  home.packages = [ pkgs.blobdrop ];
}
