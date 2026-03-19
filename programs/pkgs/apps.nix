{ pkgs, ... }: {
  home.packages = with pkgs; [
    # reverse-engineering gui for rizin, a radare2 fork
    cutter
    # reverse-engineering tools, including an advanced decompiler
    ghidra
    # very good hex editing gui
    imhex
    # kindle comic converter
    kcc
    # powerful 2d image editor with a node graph, mostly geared towards pixel art
    pixieditor
    # easy-to-use quick image editor
    sly
    # note-taking and pdf annotation
    xournalpp
  ];
}
