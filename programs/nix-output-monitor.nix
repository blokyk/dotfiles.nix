{ lib, ... }: {
  nixpkgs.overlays = [(final: prev: {
    # the upstream repo already includes packaging for it in `default.nix`,
    # but it unfortunately hides a few packaging details in the flake :(
    nix-output-monitor =
      let
        hlib = final.haskell.lib.compose;
        base-nom = final.haskellPackages.callPackage <nom/nix-output-monitor> {};
      in
        lib.pipe base-nom [
          final.haskellPackages.buildFromCabalSdist
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
  })];
}
