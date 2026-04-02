{ ... }: {
  home.language = {
    base = "en_US.UTF-8";

    time = "fr_FR.UTF-8";
    paper = "fr_FR.UTF-8"; # use ISO paper sizes
    telephone = "fr_FR.UTF-8";
  };

  home.keyboard = {
    layout = "fr";
    options = [
      "nbsp:none" # disable non-breaking space on altgr+space
    ];
  };
}
