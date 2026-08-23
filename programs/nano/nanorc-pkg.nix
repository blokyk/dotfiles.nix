{
  fetchurl,
  nanorc,
  ...
}:
let
  nix-nanorc = <nanonix/nix.nanorc>;
  typst-nanorc = fetchurl {
    url = "https://gist.github.com/blokyk/5c3ee32c8661975b97994c2210b01296/raw/fd33f8a074644bee74655247f3f808753b0364e1/typst.nanorc";
    hash = "sha256-n86KUjSOHwSP6mgzkDUvAo8gSQgjqCUZq6k1TitYD2k=";
  };
in
nanorc.overrideAttrs (prev: {
  src = <nano-syntax-highlighting>;

  postUnpack = (prev.postUnpack or "") + ''
    cp "${nix-nanorc}" "$sourceRoot/nix.nanorc"
    cp "${typst-nanorc}" "$sourceRoot/typst.nanorc";
  '';

  patches = [ ./git-commit-highlight-long-message.patch ];
})
