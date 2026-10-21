{
  mkShellCutter,
}:
{
  passthru.shell = mkShellCutter {
    name = "rust.shell";
    devshell = ./shell.nix;
  };
}
