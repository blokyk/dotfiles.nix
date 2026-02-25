{ pkgs, ... }: {
  home.packages = [ pkgs.nixd ];
  home.sessionVariables.NIXD_FLAGS = "-log=error";
}