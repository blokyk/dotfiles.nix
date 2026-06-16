{ lib, pkgs, ... }:
let
  sh = lib.getExe pkgs.stdenv.shellPackage;
  sed = lib.getExe pkgs.gnused;
  bat = lib.getExe pkgs.bat;
in {
  home.sessionVariables.MANPAGER = ''
    ${sh} -c '${sed} -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | ${bat} -p -lman''\'
  '';
}
