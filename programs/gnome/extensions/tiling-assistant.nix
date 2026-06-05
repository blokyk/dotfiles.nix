{ lib, pkgs, ... }: {
  imports = [
    (lib.modules.importApply <zoeee/hm-modules/mk-keybindings> {
      optPath = [ "programs" "gnome-shell" "tiling-assistant" "keybindings" ];
      prefixPath = [ "dconf" "settings" "org/gnome/shell/extensions/tiling-assistant" ];
    })
  ];

  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."tiling-assistant@ubuntu.com";
  }];

  programs.gnome-shell.tiling-assistant.keybindings = {
    tile-left-half  = ["<Super>" "Left"];
    tile-right-half = ["<Super>" "Right"];
    tile-maximize   = ["<Super>" "Up"];
  };
}
