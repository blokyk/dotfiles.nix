{
  bat,
  coreutils,
  figlet,
  fzf,
  gawk,
  gh,
  gnused,
  jq,
  lix-diff,
  nix-impl-cli,
  nix-output-monitor,
  npins,
  ripgrep,
  xclip,
  unixtools,

  callPackage,
  writeShellApplication,
  ...
}:
let
  read = builtins.readFile;
in rec {
  clock = writeShellApplication {
    name = "clock";
    runtimeInputs = [ coreutils figlet unixtools.watch ];
    text = read ./clock.sh;
  };

  dircnt = callPackage ./dircnt {};

  figlet-fzf = writeShellApplication {
    name = "figlet-fzf";
    runtimeInputs = [ figlet fzf xclip ];
    excludeShellChecks = [ "SC2016" "SC2034" ];
    text = read ./figlet-fzf.sh;
  };

  hm-diff = writeShellApplication {
    name = "hm-diff";
    runtimeInputs = [ coreutils gawk lix-diff /*home-manager*/ ];
    text = read ./hm-diff.sh;
  };

  hm-switch = writeShellApplication {
    name = "hm-switch";
    runtimeInputs = [ nix-output-monitor npins-shell ];
    text = read ./hm-switch.sh;
  };

  issue-fzf = writeShellApplication {
    name = "issue-fzf";
    runtimeInputs = [ coreutils fzf gh gnused /* $EDITOR */ ];
    excludeShellChecks = [ "SC2016" ];
    text = read ./issue-fzf.sh;
  };

  nix-drv-out = writeShellApplication {
    name = "nix-drv-out";
    runtimeInputs = [ jq nix-impl-cli ];
    text = read ./nix-drv-out.sh;
  };

  nixp = writeShellApplication {
    name = "nixp";
    runtimeInputs = [ coreutils fzf nix-impl-cli /* $EDITOR */ ];
    text = read ./nixp.sh;
  };

  npins-shell = writeShellApplication {
    name = "npins-shell";
    runtimeInputs = [ coreutils npins ];
    text = read ./npins-shell.sh;
  };

  pr-fzf = writeShellApplication {
    name = "pr-fzf";
    runtimeInputs = [ coreutils fzf gh ];
    excludeShellChecks = [ "SC2016" ];
    text = read ./pr-fzf.sh;
  };

  frg = writeShellApplication {
    name = "frg";
    runtimeInputs = [ bat fzf ripgrep ];
    excludeShellChecks = [ "SC2016" ];
    text = read ./rg-fzf.sh;
  };
}
