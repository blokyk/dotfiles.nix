{ ... }: {
  imports = [ (import <zoeee/hm-modules>) ];

  programs.zsh-powerlevel10k = {
    enable = true;
  };
}
