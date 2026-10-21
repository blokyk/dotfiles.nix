{ lib, pkgs, ... }:
let
  gv = lib.hm.gvariant;
  toggle-spec-type = gv.type.dictionaryEntryOf [gv.type.string gv.type.variant];

  mkToggle = name: enabled: with gv; [
    (mkDictionaryEntry ["hide" (mkVariant (!enabled))])
    (mkDictionaryEntry ["isSystem" (mkVariant true)])
    (mkDictionaryEntry ["constructorName" (mkVariant name)])
  ];

  # fixme: this isn't ordered
  toggles = {
    NMWiredToggle = true;
    NMWirelessToggle = true;
    NMModemToggle = true;
    NMBluetoothToggle = true;
    NMVpnToggle = false;
    BluetoothToggle = true;
    RfkillToggle = false; # airplane mode

    PowerProfilesToggle = true;
    NightLightToggle = false;
    DarkModeToggle = false;

    DoNotDisturbToggle = false;
    DndQuickToggle = false;

    KeyboardBrightnessToggle = true;
    RotationToggle = false;
    UnsafeQuickToggle = false;
  };
in {
  programs.gnome-shell.extensions = [{
    package = pkgs.gnomeCurrentExtensions."quick-settings-tweaks@qwreey"; }
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      toggles-layout-order = with gv; mkArray (type.arrayOf toggle-spec-type) (
        (lib.mapAttrsToList mkToggle toggles) ++ [
          # [
          #   (mkDictionaryEntry ["hide" (mkVariant false)])
          #   (mkDictionaryEntry ["nonOrdered" (mkVariant true)])
          # ]
        ]
      );

      #   # { hide = false; isSystem = true; constructorName = "NMWiredToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "NMWirelessToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "NMModemToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "NMBluetoothToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "NMVpnToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "BluetoothToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "PowerProfilesToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "NightLightToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "DarkModeToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "DoNotDisturbToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "KeyboardBrightnessToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "RfkillToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "RotationToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "DndQuickToggle"; }
      #   # { hide = false; isSystem = true; constructorName = "UnsafeQuickToggle"; }
      #   # { nonOrdered = true; hide = false; }
      # ];
    };
  };
}
