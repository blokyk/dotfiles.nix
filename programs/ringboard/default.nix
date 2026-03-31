# A clipboard history manager
{ pkgs, ... }:
let
  toTOML = (pkgs.formats.toml { }).generate;
in {
  imports = [ (import <zoeee/hm-modules>) ];

  services.ringboard = {
    client.package = pkgs.callPackage ./package.nix { };
    x11.enable = true;
  };

  xdg.configFile = {
    "ringboard/x11.toml".source = toTOML "ringboard-x11-config.toml" {
      version = "V1";
      auto_paste = false;
      fast_path_optimzations = false; # allows ringboard to not keep passwords
    };
  };
}
