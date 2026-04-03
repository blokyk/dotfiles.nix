{ lib, pkgs, ... }:
let
  nix-flake-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
in {
  # necessary because firefox overwrites it (with the same content) and then home-manager complains
  home.file.".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;

  programs.firefox.profiles.default.search = {
    default = "google";
    privateDefault = "google";

    engines = {
      nixp = {
        name = "nixpkgs search";
        definedAliases = [ "nixp" ];
        icon = nix-flake-icon;

        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "channel"; value = "unstable"; }
            { name = "query";   value = "{searchTerms}"; }
          ];
        }];
      };

      nixos = {
        name = "nixos options search";
        definedAliases = [ "nixos" ];
        icon = nix-flake-icon;

        urls = [{
          template = "https://search.nixos.org/options";
          params = [
            { name = "channel"; value = "unstable"; }
            { name = "query";   value = "{searchTerms}"; }
          ];
        }];
      };

      hm = {
        name = "home-manager option search";
        definedAliases = [ "hm" ];
        icon = nix-flake-icon;

        urls = [{
          template = "https://home-manager-options.extranix.com/";
          params = [
            { name = "release"; value = "master"; }
            { name = "query";   value = "{searchTerms}"; }
          ];
        }];
      };

      # hide other builtin engines
      bing.metaData.hidden = true;
      perplexity.metaData.hidden = true;
      qwant.metaData.hidden = true;
      duckduckgo.metaData.hidden = true;
    };
  };
}
