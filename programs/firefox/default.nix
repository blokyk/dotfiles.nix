{ config, ... }: {
  imports = [ ./search.nix ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      bookmarks = {
        enable = true;
        force = true;
        settings = [
          { name = "gh"; keyword = "gh"; url = "https://github.com/%S"; }
        ];
        configFile = config.lib.file.mkOutOfStoreSymlink ./bookmarks.json;
      };
    };
  };
}
