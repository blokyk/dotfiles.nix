{
  coreutils,
  fzf,
  gawk,

  callPackage,
  symlinkJoin,
  writeShellApplication,
}:
let
  all-thes = symlinkJoin {
    name = "thes";
    paths = [
      (callPackage ./en-thes.nix {})
      (callPackage ./fr-thes.nix {})
    ];
  };
in
writeShellApplication {
  name = "syno";
  runtimeInputs = [ coreutils fzf gawk ];
  text = builtins.readFile ./syno.sh;
  runtimeEnv.THES_DIR = all-thes;
}
