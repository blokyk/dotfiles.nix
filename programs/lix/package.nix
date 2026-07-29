{
  lix,

  cacert,
  mdbook-linkcheck2,
  mimalloc,
}:
lix.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [
    # undo the new boring 'unpack tarfile' message and
    # add back the old-new 'unpack %s' progress bar
    ./unpack-progress.patch
  ];

  nativeBuildInputs = prev.nativeBuildInputs ++ [ mdbook-linkcheck2 cacert ];
  buildInputs = prev.buildInputs ++ [ mimalloc ];

  doCheck = false;
  doInstallCheck = false;
})
