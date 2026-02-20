{
  bat,
  figlet,
  fzf,
  gh,
  jq,
  lix-diff,
  nano,
  nix-impl-cli,
  ripgrep,
  xclip,

  writeShellApplication,
  ...
}: {
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