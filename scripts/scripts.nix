{
  bat,
  figlet,
  fzf,
  gh,
  jq,
  lix-diff,
  nano,
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
    runtimeInputs = [ lix-diff /*home-manager*/ ];
    text = builtins.readFile ./hm-diff.sh;
  };

  hm-switch = writeShellApplication {
    name = "hm-switch";
    runtimeInputs = [ nix-output-monitor npins-shell ];
    text = builtins.readFile ./hm-switch.sh;
  };

  issue-fzf = writeShellApplication {
    name = "issue-fzf";
    runtimeInputs = [ fzf gh ];
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
    runtimeInputs = [ fzf nix-impl-cli ];
    text = builtins.readFile ./nixp.sh;
  };

  npins-shell = writeShellApplication {
    name = "npins-shell";
    runtimeInputs = [ npins ];
    text = builtins.readFile ./npins-shell.sh;
  };

  pr-fzf = writeShellApplication {
    name = "pr-fzf";
    runtimeInputs = [ fzf gh ];
    excludeShellChecks = [ "SC2016" ];
    text = builtins.readFile ./pr-fzf.sh;
  };

  frg = writeShellApplication {
    name = "frg";
    runtimeInputs = [ bat fzf nano ripgrep ];
    excludeShellChecks = [ "SC2016" ];
    text = builtins.readFile ./rg-fzf.sh;
  };
}
