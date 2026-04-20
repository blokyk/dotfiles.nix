{ ... }: {
  imports = [
    ./keybindings.nix

    ./dash-to-dock.nix
    ./focus-changer.nix
    ./hide-top-bar.nix
  ];

  programs.gnome-shell.enable = true;

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "com.gexperts.Tilix.desktop"
      ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/desktop/interface" = {
      # disable that FUCKING middle click paste
      gtk-enable-primary-paste = false;
    };
  };
}
