{ pkgs, ... }: {
  home.packages = with pkgs; [
    # desktop client for matrix
    # fixme: broken #element-desktop
    # reverse-engineering tools, including an advanced decompiler
    ghidra
    # alternative gnome shell extension managing GUI
    # fixme: broken #gnome-extension-manager
    # very good hex editing gui
    imhex
    # open-source linux alternative to synthesia, the midi visualizer
    # fixme: no sound #neothesia
    # powerful 2d image editor with a node graph, mostly geared towards pixel art
    pixieditor
    # easy-to-use quick image editor
    sly
    # note-taking and pdf annotation
    xournalpp
  ];
}
