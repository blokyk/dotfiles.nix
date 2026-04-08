{ config, lib, ... }: {
  home.sessionVariables = {
  };

  programs.zsh.envExtra = ''
    export XDG_DATA_DIRS="${lib.concatStringsSep ":" config.xdg.systemDirs.data}"
  '';
}
