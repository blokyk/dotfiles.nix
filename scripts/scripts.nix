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

  writeShellApplication,
  ...
}: rec {
  figlet-fzf = writeShellApplication {
    name = "figlet-fzf";
    runtimeInputs = [ figlet fzf xclip ];
    excludeShellChecks = [ "SC2016" "SC2034" ];
    text = builtins.readFile ./figlet-fzf.sh;
  };

  hm-diff = writeShellApplication {
    name = "hm-diff";
    runtimeInputs = [ coreutils gawk lix-diff /*home-manager*/ ];
    text = builtins.readFile ./hm-diff.sh;
  };

  hm-switch = writeShellApplication {
    name = "hm-switch";
    runtimeInputs = [ nix-output-monitor npins-shell ];
    text = builtins.readFile ./hm-switch.sh;
  };

  issue-fzf = writeShellApplication {
    name = "issue-fzf";
    runtimeInputs = [ coreutils fzf gh gnused /* $EDITOR */ ];
    excludeShellChecks = [ "SC2016" ];
    text = builtins.readFile ./issue-fzf.sh;
  };

  nix-drv-out = writeShellApplication {
    name = "nix-drv-out";
    runtimeInputs = [ jq nix-impl-cli ];
    text = builtins.readFile ./nix-drv-out.sh;
  };

  nixp = writeShellApplication {
    name = "nixp";
    runtimeInputs = [ coreutils fzf nix-impl-cli /* $EDITOR */ ];
    text = builtins.readFile ./nixp.sh;
  };

  npins-shell = writeShellApplication {
    name = "npins-shell";
    runtimeInputs = [ coreutils npins ];
    text = builtins.readFile ./npins-shell.sh;
  };

  pr-fzf = writeShellApplication {
    name = "pr-fzf";
    runtimeInputs = [ coreutils fzf gh ];
    excludeShellChecks = [ "SC2016" ];
    text = builtins.readFile ./pr-fzf.sh;
  };

  frg = writeShellApplication {
    name = "frg";
    runtimeInputs = [ bat fzf ripgrep ];
    excludeShellChecks = [ "SC2016" ];
    text = builtins.readFile ./rg-fzf.sh;
  };
}
