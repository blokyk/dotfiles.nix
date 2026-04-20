{ config, lib, ... }: {
  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/wrappers/bin" # wrappers have a higher priority (i.e. override) system binaries
    "/run/system-manager/sw/bin"
  ];

  programs.zsh.envExtra = ''
    export XDG_DATA_DIRS="${lib.concatStringsSep ":" config.xdg.systemDirs.data}"
  '';
}
