{ lib, pkgs, ... }:
let
  redirectData = (lib.importJSON <indie-wiki-buddy-data/v1/all-data.json>).sites;
in lib.warn "implement indie wiki redirects you dummy" {
  programs.firefox.addons.settings."redirector@einaregilsson.com" = {
    settings.redirects = [ /* fixme */ ];

    # todo: also implement breezewiki redirect (cf https://breezewiki.com/)
    #       for non-matched fandom wikis (use lib.mkAfter!!)
  };
}
