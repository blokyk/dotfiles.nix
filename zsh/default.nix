{ config, ... }: {
  imports = [
    ./env.nix
    ./p10k.nix
  ];

  programs.zsh = {
    enable = false;
    enableVteIntegration = true;
    dotDir = config.xdg.configHome + "/zsh";
  };
}
