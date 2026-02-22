# todo: migrate this to system-manager
{ ... }: {
  xdg.configFile = {
    "keyd/laptop_kb.conf".text = ''
      [ids]
      # only listen to the laptop's keyboard
      048d:c999:20fedd6

      [main]
      # remap the "windows recall" key:
      #   - if pressed quickly, to right-click/context menu
      #   - if held, to leftctrl
      leftmeta+leftshift+f23 = overloadt(control, compose, 250)
    '';

    "keyd/LIZHI_USB_Keyboard.conf".text = ''
      [ids]
      # only listen to the cheap listo usb keyboard (it has two devices for some reason)
      1c4f:0040:fa50c043
      1c4f:0040:1e9f466c

      [main]
      # remap fn+f9 and fn+f10 to control the brightness
      homepage = brightnessdown
      mail     = brightnessup

      # remap fn+f1 as mute, since f2 and f3 are vol down/up
      config = mute
    '';
  };
}