{ config, ... }: {
  imports = [
    ./env.nix
    ./p10k.nix
    ./funcs.nix

    ./hooks-mod.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    enableVteIntegration = true;

    hooks = {
      chpwd = "__ls_after_cd";
    };
  };
}
