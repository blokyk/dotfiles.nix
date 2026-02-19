{ config, ... }: {
  imports = [ ./p10k.nix ];

  programs.zsh = {
    # enable = true;
    dotDir = config.xdg.configHome + "/zsh";
  };
}