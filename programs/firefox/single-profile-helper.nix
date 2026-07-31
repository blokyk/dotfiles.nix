{ config, lib, ... }:
let
  mkIfElse = cond: trueVal: falseVal: lib.mkMerge [
    (lib.mkIf cond trueVal)
    (lib.mkIf (!cond) falseVal)
  ];

  mkShortcut = old: new:
    lib.modules.mkAliasOptionModule
    (["programs" "firefox"] ++ old)
    (["programs" "firefox" "profiles" cfg.profileName] ++ new);
  cfg = config.programs.firefox;
in {
  imports = [
    (mkShortcut ["settings"] ["settings"])
    (mkShortcut ["addons"] ["extensions"]) # programs.firefox.extensions is an old deprecated option...
    (mkShortcut ["search"] ["search"])
  ];

  options = {
    programs.firefox = {
      profileName = lib.mkOption {
        type = lib.types.str;
        defaultText = ''
          "dev-edition-default" if programs.firefox.package.pname == "firefox-devedition", "default" otherwise
        '';
      };
    };
  };

  config = {
    # the default profile name for every firefox edition is "default",
    # _except_ for firefox-devedition (but not firefox-devedition-bin),
    # which uses "dev-edition-default" instead...
    programs.firefox.profileName =
      mkIfElse (lib.getName cfg.package == "firefox-devedition")
        "dev-edition-default" # specifically for firefox dev edition
        "default"; # every(?) other firefox edition
  };
}
