{ ... }: {
  imports = [
    ./search.nix
    ./extensions.nix
  ];

  programs.firefox = {
    enable = true;
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
