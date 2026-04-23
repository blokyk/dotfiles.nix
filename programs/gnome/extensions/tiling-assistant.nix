{ lib, pkgs, ... }: {
  imports = [
    (lib.modules.importApply <self/misc/mk-keybindings-impl.nix> {
      attrPath = [ "programs" "gnome-shell" "tiling-assistant" "keybindings" ];
      dconfPath = "org/gnome/shell/extensions/tilinx-assistant";
    })
  ];

  programs.gnome-shell.extensions = [{
    # despite being the same exact extension, the system-installed Ubuntu Tiling Assistant
    # has a different UUID, so on ubuntu distro gnome will see two "different" extensions
    # and enable them both, creating conflicts
    package = pkgs.gnomeExtensions.tiling-assistant.override {
      uuid = "tiling-assistant@ubuntu.com";
    };
  }];

  programs.gnome-shell.tiling-assistant.keybindings = {
    tile-left-half  = ["<Super>" "Left"];
    tile-right-half = ["<Super>" "Right"];
    tile-maximize   = ["<Super>" "Up"];
  };
}
