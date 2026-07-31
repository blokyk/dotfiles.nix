{ lib, config, ... }:
let
  cfg = config.programs.firefox;
in {
  imports = [(
    lib.modules.importApply <self/misc/importNixFilesAndDirs.nix> ./.
  )];

  options = {
    # adds programs.firefox.profiles.<name>.extensions.allowInPrivateMode
    programs.firefox.profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.extensions.allowInPrivateMode = lib.mkOption {
          type = with lib.types; listOf (coercedTo package (p: p.passthru.addonId) str);
          default = [];
          description = ''
            List of extensions to allow in private mode.
          '';
        };
      });
    };
  };

  config = {
    programs.firefox.policies.ExtensionSettings =
      lib.genAttrs' cfg.addons.allowInPrivateMode (addon: {
        name = addon;
        value.private_browsing = true;
      });
  };
}
