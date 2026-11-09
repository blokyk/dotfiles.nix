{ ... }: {
  programs.diffnav = {
    enable = true;
    enableGitIntegration = true;

    settings.ui = {
      icons = "unicode";
      theme = "one_half_dark";

      hideHeader = true;
      hideFolder = true;
    };
  };
}
