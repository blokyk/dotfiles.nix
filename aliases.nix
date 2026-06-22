{ lib, pkgs, scripts, ... }:
let
  csharprepl = lib.getExe pkgs.csharprepl;
  blobdrop = lib.getExe pkgs.blobdrop;
  gnome-text-editor = lib.getExe pkgs.gnome-text-editor;
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  syno = lib.getExe scripts.syno;
in {
  home.shellAliases = {
    ssh = "ssh -C"; # always use compression

    cdtmp = "cd $(${mktemp} -d)";

    syno-fr = "LANG=fr ${syno}";

    drag = blobdrop;
    pick = blobdrop;
    csharp = csharprepl;
    gedit = gnome-text-editor;
  };
}
