{ pkgs, ... }:
let
  nix-flake-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
in {
  programs.firefox.profiles.default.search = {
    # necessary because firefox overwrites it (with basically identical content) and then home-manager complains
    force = true;

    default = "google";
    privateDefault = "google";

    engines = {
      nixp = {
        name = "nixpkgs search";
        definedAliases = [ "nixp" ];
        icon = nix-flake-icon;

        urls = [{
          # we don't use search.nix.ee because it doesn't search for programs inside packages
          template = "https://search.nixos.org/packages?channel=unstable";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
      };

      nixos = {
        name = "nixos options search";
        definedAliases = [ "nixos" ];
        icon = nix-flake-icon;

        urls = [{
          template = "https://search.nix.ee/options/nixos/search";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
      };

      hm = {
        name = "home-manager option search";
        definedAliases = [ "hm" ];
        icon = nix-flake-icon;

        urls = [{
          template = "https://search.nix.ee/options/home-manager/search";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
      };

      # gh = {
      #   name = "github quick access";
      #   definedAliases = [ "gh" ];
      #
      #   urls = [{
      #     template = "https://github.com/{searchTerms}";
      #   }];
      # };

      # hide other builtin engines
      bing.metaData.hidden = true;
      perplexity.metaData.hidden = true;
      qwant.metaData.hidden = true;
      duckduckgo.metaData.hidden = true;
    };
  };
}
