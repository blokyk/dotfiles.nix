{
  lix,

  cacert,
  mdbook-linkcheck2,
  mimalloc,
}:
lix.overrideAttrs (prev: {
  patches = (prev.patches or []) ++ [
    ./revert-unpack-tarfile.patch # first, undo the new boring 'unpack tarfile' message
    ./unpack-progress.patch       # then, add back the old-new 'unpack %s' progress bar
  ];

  nativeBuildInputs = prev.nativeBuildInputs ++ [ mdbook-linkcheck2 cacert ];
  buildInputs = prev.buildInputs ++ [ mimalloc ];

  doCheck = false;
  doInstallCheck = false;
})
