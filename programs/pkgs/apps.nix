{ pkgs, ... }: {
  home.packages = with pkgs; [
    # very good hex editing gui
    imhex
    # easy-to-use quick image editor
    sly
  ];

  # broken:
  #   - element-desktop
  #   - gnome-extension-manager
  #   - neothesia (no sound)
  # removed:
  #   - ghidra
  #   - pixieditor
  #   - xournalpp
}
