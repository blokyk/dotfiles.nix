{ pkgs, ... }: {
  home.packages = with pkgs; [
    # reverse-engineering gui for rizin, a radare2 fork
    cutter
    # desktop client for matrix
    # fixme: broken #element-desktop
    # reverse-engineering tools, including an advanced decompiler
    ghidra
    # alternative gnome shell extension managing GUI
    # fixme: broken #gnome-extension-manager
    # very good hex editing gui
    imhex
    # kindle comic converter
    kcc
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
