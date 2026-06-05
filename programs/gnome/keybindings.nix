{ lib, ... }:
let inherit (lib.modules) importApply; in
{
  imports = [
    (importApply <zoeee/hm-modules/mk-keybindings> {
      optPath = [ "programs" "gnome-shell" "keybindings" ];
      prefixPath = [ "dconf" "settings" "org/gnome/shell/keybindings" ];
    })

    (importApply <zoeee/hm-modules/mk-keybindings> {
      optPath = [ "programs" "gnome-desktop" "keybindings" ];
      prefixPath = [ "dconf" "settings" "org/gnome/desktop/wm/keybindings" ];
    })
  ];

  # todo: impl custom keybindings

  programs.gnome-shell.keybindings = {
    # this is ctrl+v by default, which we instead want to bind to ringboard
    toggle-message-tray = null;
  };

  programs.gnome-desktop.keybindings = {
    # close (minimize) windows by doing Win+↓
    minimize = ["<Super>" "Down"];

    # this is alt+space by default, which is used by vscode (among others)
    activate-window-menu = null;

    # this is Win/Alt+² by default, which i use in vscode (and ideally others)
    # for a less cramped ctrl+tab (switch tab) shortcut
    switch-group = null;
    switch-group-backward = null;
  };
}
