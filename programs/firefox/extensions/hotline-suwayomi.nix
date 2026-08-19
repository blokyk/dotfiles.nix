{ pkgs, ... }:
let
  hotline-suwayomi = pkgs.callPackage <hotline-suwayomi/package.nix> { };
in {
  # nixpkgs.overlays = [(
  #   final: prev: {
  #     firefox-addons = prev.firefox-addons.extend ({
  #       hotline-suwayomi = ;
  #     });
  #   }
  # )];

  programs.firefox.addons = {
    packages = [ hotline-suwayomi ];
    allowInPrivateMode = [ "@blokyk.hotline-suwayomi" ];

    settings."@blokyk.hotline-suwayomi" = {
      force = true;
      settings = {
        # fixme: doesn't work :(
        #suwayomi_url = "https://manga.zoeee.net";
      };
    };
  };
}
