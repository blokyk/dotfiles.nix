{ pkgs, ... }:
let
  nix-flake-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

  wikipedia-icon = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/en/8/80/Wikipedia-logo-v2.svg";
    hash = "sha256-kOAe969TprYk+iTuOkjH1t2fVbD5mbyMcwP40ons15g=";
  };

  wikitionary-icon = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/f/ff/WiktionaryEn.svg";
    hash = "sha256-BPEQnuk2mm/ciChFzEnzH9DLAPJQI3ev+vHfabjMS00=";
  };

  yt-icon = pkgs.fetchurl {
    name = "youtube-logo.svg";
    url = "https://upload.wikimedia.org/wikipedia/commons/f/fd/YouTube_full-color_icon_%282024%29.svg";
    hash = "sha256-8igmt9medFu9pU3EIcLC8IY3OyAMXn97QExNecPfaOI=";
  };
in {
  programs.firefox.search = {
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

      nptr = {
        name = "nixpkgs pr status";
        definedAliases = [ "nptr" ];

        urls = [{
          template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}";
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

      wp = {
        name = "wikipedia";
        definedAliases = [ "wp" ];
        icon = wikipedia-icon;

        urls = [{
          template = "https://en.wikipedia.org/w/index.php";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
      };

      wd = {
        name = "wikitionary (en)";
        definedAliases = [ "wd" ];
        icon = wikitionary-icon;

        urls = [{
          template = "https://en.wikitionary.org/w/index.php";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
      };

      wdf = {
        name = "wikitionary (fr)";
        definedAliases = [ "wdf" ];
        icon = wikitionary-icon;

        urls = [{
          template = "https://fr.wikitionary.org/w/index.php";
          params = [
            { name = "search"; value = "{searchTerms}"; }
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

      y = {
        name = "youtube";
        definedAliases = [ "y" ];
        icon = yt-icon;

        urls = [{
          template = "https://youtube.com/results";
          params = [
            { name = "search_query"; value = "{searchTerms}"; }
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
