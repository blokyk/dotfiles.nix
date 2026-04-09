{ config, ... }: {
  imports = [
    ./env.nix
    ./p10k.nix
  ];

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    dotDir = config.xdg.configHome + "/zsh";
  };
}
