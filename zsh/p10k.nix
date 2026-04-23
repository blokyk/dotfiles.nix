{ config, ... }: {
  imports = [ <zoeee/hm-modules>.outPath ];

  programs.zsh-powerlevel10k = {
    enable = true;
    theme = config.programs.zsh-powerlevel10k.themes.robbyrussell // {
      mode = "ascii";
    };
  };
}
