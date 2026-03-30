{ config, lib, ... }:
let
  HOME = config.home.homeDirectory;
in {
  home.sessionVariables = {
    TERM = "xterm-256color";
    ANDROID_HOME = config.home.homeDirectory + "/Android/Sdk";
  };

  xdg.systemDirs.data = lib.mkAfter [
    "/usr/share/ubuntu"
    "/usr/share/gnome"
    "/usr/local/share"
    "/usr/share"
    "/var/lib/snapd/desktop"
    "/var/lib/flatpak/exports/share"
    "/nix/var/nix/profiles/default/share"
    "${HOME}/.local/share/flatpak/exports/share"
    "${HOME}/.nix-profile/share"
  ];
}
