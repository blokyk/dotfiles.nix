{ pkgs, ... }:
let
  rycee-nur = import <rycee-nur> { inherit pkgs; };
in {
  programs.firefox.profiles.default.extensions = {
    packages = with rycee-nur.firefox-addons; [
      auto-tab-discard
      bitwarden
      darkreader
      french-dictionary
      # hotline-suwayomi
      # mpris-integration
      tab-session-manager
      ublock-origin
    ];
  };

  # don't disable extensions by default
  programs.firefox.profiles.default.settings = {
    "extensions.autoDisableScopes" = 0;
  };
}
