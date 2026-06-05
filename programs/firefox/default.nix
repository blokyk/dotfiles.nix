{ ... }: {
  imports = [
    ./search.nix
    ./extensions.nix
  ];

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.bookmarks.file" = toString ./bookmarks.html;
        "browser.places.importBookmarksHTML" = true;
        "browser.bookmarks.addedImportButton" = false;
        "browser.bookmarks.autoExportHTML" = true;
      };
    };
  };
}
