{
  fetchFromGitHub,
  nanorc,
  ...
}:
let
  nix-nanorc = <nanonix/nix.nanorc>;
in
nanorc.overrideAttrs (prev: {
  src = <nano-syntax-highlighting>;

  postUnpack = (prev.postUnpack or "") + ''
    cp ${nix-nanorc} ''$sourceRoot/nix.nanorc
  '';

  patches = [ ./git-commit-highlight-long-message.patch ];
})
