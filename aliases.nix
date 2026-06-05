{ lib, pkgs, scripts, ... }:
let
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  csharprepl = lib.getExe pkgs.csharprepl;
  gnome-text-editor = lib.getExe pkgs.gnome-text-editor;
  syno = lib.getExe scripts.syno;
in {
  home.shellAliases = {
    ssh = "ssh -C"; # always use compression

    cdtmp = "cd $(${mktemp} -d)";

    syno-fr = "LANG=fr ${syno}";

    csharp = csharprepl;
    gedit = gnome-text-editor;
  };
}
