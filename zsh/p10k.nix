{ config, ... }: {
  imports = [ (import <zoeee/hm-modules>) ];

  programs.zsh-powerlevel10k = {
    enable = true;
    theme = config.programs.zsh-powerlevel10k.themes.robbyrussell // {
      mode = "ascii";
    };
  };
}
