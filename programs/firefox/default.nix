{ config, ... }: {
  imports = [
    ./search.nix
    ./extensions.nix
    ./single-profile-helper.nix
  ];

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    settings = {
      "browser.bookmarks.file" = toString ./bookmarks.html;
      "browser.places.importBookmarksHTML" = true;
      "browser.bookmarks.addedImportButton" = false;
      "browser.bookmarks.autoExportHTML" = true;
    };
  };
}
