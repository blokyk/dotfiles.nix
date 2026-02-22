{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  # we use writable symlinks instead of standard nix files because it'd be
  # annoying to have to constantly do a `home-manager switch` just to try
  # out keybindings or settings.
  # since they are symlinks, if they are modified in vscode, they'll show
  # up as dirty here so we still get traceability
  xdg.configFile = {
    "Code/User/settings.json".source = mkOutOfStoreSymlink ./settings.json;
    "Code/User/keybindings.json".source = mkOutOfStoreSymlink ./keybindings.json;
  };
}