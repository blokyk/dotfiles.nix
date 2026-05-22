{
  nanorc,
  ...
}:
let
  nix-nanorc = <nanonix/nix.nanorc>;
in
nanorc.overrideAttrs (prev: {
  postUnpack = (prev.postUnpack or "") + ''
    cp ${nix-nanorc} ''$sourceRoot/nix.nanorc
  '';

  patches = [ ./git-commit-highlight-long-message.patch ];
})
