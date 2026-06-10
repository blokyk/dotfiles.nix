{ ... }: {
  imports = [ ./impl ];

  programs.zsh.z8h = {
    enable = true;
  };
}
