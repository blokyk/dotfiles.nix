{ ... }: {
  imports = [ ./impl ];

  programs.z8h = {
    enable = true;
  };
}
