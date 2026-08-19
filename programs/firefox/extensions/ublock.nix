{ pkgs, ... }: {
  programs.firefox.addons = {
    packages = [ pkgs.firefox-addons.ublock-origin ];
    allowInPrivateMode = [ "uBlock0@raymondhill.net" ];

    settings."uBlock0@raymondhill.net" = {
      force = true;
      settings = {
        selectedFilterLists = [
          # built-in
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "ublock-unbreak"

          # ads
          "easylist"
          "adguard-generic"
          "adguard-mobile"

          # privacy
          "easyprivacy"
          "adguard-spyware-url"

          # malware/phishing protection
          "urlhaus-1"
          "curben-phishing"

          # cookie notices
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"

          # annoyances
          "fanboy-ai-suggestions"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "ublock-annoyances"

          # misc
          "plowe-0" # Peter Lowe’s Ad and tracking server list
          "user-filters" # the custom 'My filters' list
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
