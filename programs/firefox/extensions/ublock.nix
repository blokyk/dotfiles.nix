{ pkgs, ... }: {
  programs.firefox.addons = {
    packages = [ pkgs.firefox-addons.ublock-origin ];
    allowInPrivateMode = [ "uBlock0@raymondhill.net" ];

    settings."uBlock0@raymondhill.net" = {
      settings = {
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"
        ];

        user-filters = ''
          ! Hide the "AI Mode" option in the search menu
          www.google.com##.O1uzAe.beZ0tf > div:nth-of-type(1)

          ! Hide "AI Summary" from search result
          www.google.com###rso > .ULSxyf
        '';
      };
    };
  };
}
