{ config, pkgs, ... }: {
  imports = [
    ./search.nix
    ./extensions.nix
    ./single-profile-helper.nix
  ];

  programs.firefox = {
    enable = true;
    # use dev version for unsigned addon support
    package = pkgs.firefox-devedition;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    settings = {
      "browser.bookmarks.file" = toString ./bookmarks.html;
      "browser.places.importBookmarksHTML" = true;
      "browser.bookmarks.addedImportButton" = false;
      "browser.bookmarks.autoExportHTML" = true;
    };
  };
}
