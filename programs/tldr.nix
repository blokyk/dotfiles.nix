# 'tldr.sh' client written in rust, for when manpages are too long
{ pkgs, ... }: {
  home.packages = [ pkgs.tlrc ];

  services.tldr-update = {
    enable = true;
    period = "daily";
  };
}
