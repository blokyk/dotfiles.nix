{
  fetchFromGitHub,
  nanorc,
  ...
}:
let
  nix-nanorc = <nanonix/nix.nanorc>;
in
nanorc.overrideAttrs (prev: {
  src = fetchFromGitHub {
    owner = "galenguyer";
    repo = "nano-syntax-highlighting";
    rev = "a1df5b66aabe9048b13b58beec1e61abbd729c77";
    hash = "sha256-tcRNoeg0j/z9wFZjIc1CJXOKieWrvlLq9pblB0kE6yc=";
  };

  postUnpack = (prev.postUnpack or "") + ''
    cp ${nix-nanorc} ''$sourceRoot/nix.nanorc
  '';

  patches = [ ./git-commit-highlight-long-message.patch ];
})
