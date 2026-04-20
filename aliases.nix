{ lib, pkgs, scripts, ... }:
let
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  xclip  = lib.getExe  pkgs.xclip;
  csharprepl = lib.getExe pkgs.csharprepl;
  gnome-text-editor = lib.getExe pkgs.gnome-text-editor;
  syno = lib.getExe scripts.syno;
in {
  home.shellAliases = {
    la = "ls -A";
    ll = "ls -lha";
    lspci = "lspci -tv";
    ip = "ip -c"; # always use color
    ssh = "ssh -C"; # always use compression
    tree = "tree -a -I .git";

    cdtmp = "cd $(${mktemp} -d)";
    clipcopy = "${xclip} -sel clip";
    clippaste = "${xclip} -sel clip -o";

    wdf = "watch -n .5 df -h";
    syno-fr = "LANG=fr ${syno}";

    csharp = csharprepl;
    gedit = gnome-text-editor;
  };
}
