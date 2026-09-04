{ pkgs, ... }: {
  imports = [ ./redirector-indie-wiki.nix ];

  programs.firefox.addons = {
    packages = [ pkgs.firefox-addons.redirector ];
    allowInPrivateMode = [ "redirector@einaregilsson.com" ];

    settings."redirector@einaregilsson.com" = {
      force = true;
      settings = {
        redirects = [
          {
            description = "redirect to official nixos wiki";

            exampleUrl = "https://nixos.wiki/wiki/Overview_of_the_Nix_Language";
            exampleResult = "https://wiki.nixos.org/wiki/Overview_of_the_Nix_Language";

            includePattern = "https://nixos.wiki/wiki/*";
            redirectUrl = "https://wiki.nixos.org/wiki/$1";

            processMatches = "noProcessing";

            excludePattern = "https://nixos.wiki/wiki/*?force=true";

            patternDesc = "";
            patternType = "W"; # wildcard

            error = null;
            disabled = false;
            grouped = false;
            appliesTo = [
                "main_frame"
            ];
          }
        ];
      };
    };
  };
}
