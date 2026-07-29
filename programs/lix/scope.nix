{
  callPackage,
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
      hash = "sha256-WbSHmK8d8SLF1WqB9NZTBa18/pQSXtnZzygIIc8AEEM=";
    };
  };
}).overrideScope (finalScope: prevScope: {
  lix = callPackage ./package.nix { inherit (prevScope) lix; };
})
