{
  callPackage,
  lib,

  clangStdenv,
  lixPackageSets,
  rustPlatform,
}:
(lixPackageSets.makeLixScope {
  attrName = "custom";

  lix-args = rec {
    version = "2.96.0-custom";

    src = builtins.storePath <lix>;

    cargoDeps = rustPlatform.fetchCargoVendor {
      name = "lix-${version}";
      inherit src;
      hash = "";
    };
  };
}).overrideScope (finalScope: prevScope: {
  lix = (callPackage <lix/package.nix> { stdenv = clangStdenv; })
    .overrideAttrs (final: prev: {
      patches = (prev.patches or []) ++ [
        # undo the new boring 'unpack tarfile' message and
        # add back the old-new 'unpack %s' progress bar
        ./unpack-progress.patch
      ];

      doCheck = false;
      doInstallCheck = false;
    });
})
