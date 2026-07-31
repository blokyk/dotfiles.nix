{ pkgs, ... }: {
  imports = [ ./extensions ];

  nixpkgs.overlays = [(
    final: prev: {
      # firefox-addons = lib.makeExtensible (_: (import <rycee-nur> { pkgs = final; }).firefox-addons);
      inherit (import <rycee-nur> { pkgs = final; }) firefox-addons;
    }
  )];

  programs.firefox.addons = {
    packages = with pkgs.firefox-addons; [
      auto-tab-discard
      bitwarden
      darkreader
      french-dictionary
      # mpris-integration
      tab-session-manager
    ];
  };

  programs.firefox.settings = {
    # don't disable extensions by default (wtf firefox??????????)
    "extensions.autoDisableScopes" = 0;

    # disable extension signing verification
    "xpinstall.signatures.required" = false;
    "extensions.langpacks.signatures.required" = false;

    # store extension settings in json instead of IndexedDB
    "extensions.webextensions.ExtensionStorageIDB.enabled" = false;
  };
}
