{ lib, pkgs, scripts, ... }:
let
  csharprepl = lib.getExe pkgs.csharprepl;
  blobdrop = lib.getExe pkgs.blobdrop;
  gnome-text-editor = lib.getExe pkgs.gnome-text-editor;
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  syno = lib.getExe scripts.syno;
in {
  home.shellAliases = {
    # todo: should be a normal alias
    ssh = "ssh -C"; # always use compression

    cdtmp = "pushd $(${mktemp} -d)";

    syno-fr = "LANG=fr ${syno}";
    pwdcp = "pwd | head -c -1 | clipcopy"; # todo: use `aliases.clipcopy` (when that's a thing)

    drag = blobdrop;
    pick = blobdrop;
    csharp = csharprepl;
    gedit = gnome-text-editor;
  };
}
