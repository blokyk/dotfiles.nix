# GNOME Terminal fork with split panes and added functionality
{ config, lib, pkgs, ... }: {
  # fix tilix using weird XDG_DATA_DIRS value that fucks up the fonts :(
  nixpkgs.overlays = [
    (final: prev: {
      tilix = prev.tilix.overrideAttrs (final: prev: {
        preFixup =
          let
            mkPrefixOpt = dir: "--prefix XDG_DATA_DIRS ':' ${dir}";
          in ''
          gappsWrapperArgs+=(
            ${lib.concatMapStringsSep "\n" mkPrefixOpt config.xdg.systemDirs.data}
          )
        '';
      });
    })
  ];

  home.packages = [ pkgs.tilix ];

  # set tilix as the default terminal in gnome
  # 1) "modern" but only works if XDG_DATA_DIRS contains ~/.nix-profile/share
  xdg.configFile."xdg-terminals.list".text = ''
    com.gexperts.Tilix.desktop
    org.gnome.Terminal.desktop
  '';
  # 2) "deprecated" but still mostly works
  dconf.settings."org/gnome/desktop/applications/terminal".exec = lib.getExe pkgs.tilix;

  imports = [(lib.modules.importApply <self/misc/mk-keybindings-impl.nix> {
    attrPath = [ "programs" "tilix" "keybindings" ];
    dconfPath = "com/gexperts/Tilix/keybindings";
    multiKeybindings = false;
  })];

  programs.tilix.keybindings = {
    terminal-copy =  [ "<Primary>" "c" ];  # ctrl+c
    terminal-paste = [ "<Primary>" "v" ]; # ctrl+v

    session-add-auto = [ "<Primary>" "t" ];

    app-new-session = [ "<Primary>" "<Shift>" "n" ];
    app-new-window =  [ "<Primary>" "n" ];
  };

  dconf.settings = {
    "com/gexperts/Tilix" = {
      # don't show tab bar when there's a single tab
      terminal-title-show-when-single = false;
      # editting the title bar requires Ctrl+click, not just click
      control-click-titlebar = true;
    };
  };

  xdg.configFile = {
    # modified dracula
    "tilix/schemes/dracula.json".text = builtins.toJSON {
      name = "Dracula (modified)";
      comment = "Ported for Terminix Colour Scheme";

      use-badge-color = false;
      use-bold-color = false;
      use-cursor-color = false;
      use-highlight-color = false;
      use-theme-colors = false;

      foreground-color = "#f8f8f2";
      background-color = "#181818";
      cursor-background-color = "#000000";
      cursor-foreground-color = "#ffffff";
      highlight-background-color = "#000000";
      highlight-foreground-color = "#ffffff";

      palette = [
        "#000000"
        "#ff5555"
        "#50fa7b"
        "#f1fa8c"
        "#bd93f9"
        "#ff79c6"
        "#8be9fd"
        "#bbbbbb"
        "#555555"
        "#ff5555"
        "#50fa7b"
        "#f1fa8c"
        "#bd93f9"
        "#ff79c6"
        "#8be9fd"
        "#ffffff"
      ];
    };
  };
}
