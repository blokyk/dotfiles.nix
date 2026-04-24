{ lib, pkgs, ... }: {
  imports = [
    (lib.modules.importApply <self/misc/mk-keybindings-impl.nix> {
      attrPath = [ "programs" "gnome-shell" "tiling-assistant" "keybindings" ];
      dconfPath = "org/gnome/shell/extensions/tilinx-assistant";
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
