{ lib, pkgs, ... }: {
  imports = [
    (lib.modules.importApply <self/misc/mk-keybindings-impl.nix> {
      attrPath = [ "programs" "gnome-shell" "tiling-assistant" "keybindings" ];
      dconfPath = "org/gnome/shell/extensions/tilinx-assistant";
    })
  ];

  # (mkAfter to ensure it comes after the original `gnomeCurrentExtensions` declaration)
  nixpkgs.overlays = lib.mkAfter [
    (finalPkgs: prevPkgs: {
      gnomeCurrentExtensions = prevPkgs.gnomeCurrentExtensions // {
        # despite being the same exact extension, the system-installed Ubuntu Tiling Assistant
        # has a different UUID, so on ubuntu distro gnome will see two "different" extensions
        # and enable them both, creating conflicts
        "tiling-assistant@ubuntu.com" =
          lib.pipe prevPkgs.gnomeCurrentExtensions."tiling-assistant@leleat-on-github" [
            (pkg: pkg.override { uuid = "tiling-assistant@ubuntu.com"; })
            (pkg: pkg.overrideAttrs (finalAttrs: prevAttrs: {
              src = prevPkgs.fetchFromGitHub {
                owner = "ubuntu";
                repo = "Tiling-Assistant";
                rev = "d8f38fc0e223a303ca4c87a06be6e4ce3cd3111c";
                hash = "sha256-sgEKvCveIawu+YeQCYO7O47eBNHMBUMgPTjgyrynISs=";
              };
              sourceRoot = "${finalAttrs.src.name}/tiling-assistant@leleat-on-github";
            }))
          ];
      };
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
