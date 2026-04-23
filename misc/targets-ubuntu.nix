{ config, lib, ... }:
let
  inherit (lib.types) anything attrsOf enum nullOr;
  cfg = config.targets.ubuntu;
in
{
  options.targets.ubuntu = {
    enable = lib.mkEnableOption "" // {
      description = ''
        Whether the current system is an Ubuntu distro.
      '';
    };
    version = lib.mkOption {
      type = nullOr (enum [
        "24.04"
        "25.04"
        "25.10"
      ]);
      description = ''
        The current version of Ubuntu.
        This helps automatically determine some information about the current target.
      '';
    };
  };

  options.targets.genericLinux = {
    extraInfo = lib.mkOption {
      type = attrsOf anything;
      description = ''
        A freeform attrset to store any kind of extra information of the current target.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    targets.genericLinux = {
      enable = true;
      extraInfo = lib.mkIf (cfg.version != null) (
        let
          ubuntuVersionExtraInfo = {
            "24.04" = {
              gnome.version = 46;
            };
            "25.04" = {
              gnome.version = 48;
            };
            "25.10" = {
              gnome.version = 49;
            };
          };
        in
          ubuntuVersionExtraInfo.${cfg.version}
      );
    };
  };
}
