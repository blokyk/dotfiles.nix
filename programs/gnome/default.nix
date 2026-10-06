{ ... }: {
  imports = [
    ./extensions
    ./keybindings.nix
  ];

  programs.gnome-shell.enable = true;

  dconf.settings = {
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/desktop/interface" = {
      # disable that FUCKING middle click paste
      gtk-enable-primary-paste = false;
    };
  };
}
