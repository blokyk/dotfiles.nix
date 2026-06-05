{ config, lib, pkgs, ... }:
let
  sh = lib.getExe pkgs.stdenv.shellPackage;
  sed = lib.getExe pkgs.gnused;
  bat = lib.getExe pkgs.bat;
in {
  home.sessionVariables = {
    XDG_DATA_DIRS = lib.mkForce "${lib.concatStringsSep ":" config.xdg.systemDirs.data}:\${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}";
    MANPAGER = ''${sh} -c '${sed} -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | ${bat} -p -lman''\''';
  };

  home.sessionPath = [
    "/run/wrappers/bin" # wrappers have a higher priority (i.e. override) system binaries
    "/run/system-manager/sw/bin"
  ];
}
