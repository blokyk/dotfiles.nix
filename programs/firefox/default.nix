{ config, pkgs, ... }: {
  imports = [
    ./search.nix
    ./extensions.nix
    ./single-profile-helper.nix
  ];

  # enable smooth scrolling and touchpad gestures
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";

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

      # ensures that firefox *always* sends touch events correctly
      "dom.w3c_touch_events.enabled" = 1;
    };
  };
}
