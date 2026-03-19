{ pkgs, ... }: {
  home.packages = with pkgs; [
    # reverse-engineering gui for rizin, a radare2 fork
    cutter
    # reverse-engineering tools, including an advanced decompiler
    ghidra
    # kindle comic converter
    kcc
    # note-taking and pdf annotation
    xournalpp
  ];
}
