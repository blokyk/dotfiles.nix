# These are functions that wouldn't work when wrapped inside a
# sub-shell (e.g. chdir), or that are exclusive to zsh.
{ lib, pkgs, scripts, ... }:
let
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  mkdir = lib.getExe' pkgs.coreutils "mkdir";
  rm = lib.getExe' pkgs.coreutils "rm";
  cat = lib.getExe' pkgs.coreutils "cat";
  cut = lib.getExe' pkgs.coreutils "cut";
  head = lib.getExe' pkgs.coreutils "head";
  tail = lib.getExe' pkgs.coreutils "tail";
  ls = lib.getExe' pkgs.coreutils "ls";
  git = lib.getExe pkgs.git;
  yazi = lib.getExe pkgs.yazi;
  dircnt = lib.getExe scripts.dircnt;
in {
  programs.zsh.siteFunctions = {
    mkclone = ''
      if [[ "$1" = "" ]]; then
          echo "Usage : mkclone [repo-dir] <options...>"
          return 1
      else
          dst="$(${mktemp} -d)"
          ${git} clone "$1" "$dst" --quiet --depth 1 "''${@:2}" && chdir "$dst"
          return $?
      fi
    '';

    cdmk = ''
      if [[ "$1" = "" ]]; then
          echo "Usage : cdmk [dirname]"
          return 1
      else
          ${mkdir} -p "$1" && chdir "$1"
          return $?
      fi
    '';

    y = ''
      local tmp="$(${mktemp} -t "yazi-cwd.XXXXXX")" cwd
      ${yazi} "$@" --cwd-file="$tmp"
      if cwd="$(${cat} -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin pushd -- "$cwd"
      fi
      ${rm} -f -- "$tmp"
    '';

    __ls_after_cd = ''
      cnt_output="$(${dircnt} ./ | ${cut} -f1 -d' ')"

      files=$(echo "$cnt_output" | ${head} -n 1)
      dirs=$(echo "$cnt_output" | ${tail} -n 1)
      total=$((files + dirs))

      if ((total > 50)); then
          echo -e "\x1b[3;2m$files files, $dirs subdirs\x1b[0m"
      else
          ${ls} --color=tty
      fi
    '';
  };
}
