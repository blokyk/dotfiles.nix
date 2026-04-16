{ lib, pkgs, ... }:
let
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  xclip  = lib.getExe  pkgs.xclip;
in {
  home.shellAliases = {
    ll = "ls -lha";
    la = "ls -A";
    ip = "ip -c";
    tree = "tree -a -I .git";

    cdtmp = "cd $(${mktemp} -d)";
    clipcopy = "${xclip} -sel clip";
    clippaste = "${xclip} -sel clip -o";
  };
}
