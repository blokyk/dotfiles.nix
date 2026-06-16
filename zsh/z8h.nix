{ ... }: {
  programs.z8h = {
    enable = true;
    keybindings = {
      z4h-stash-buffer = [ "<Ctrl>" "S" ];
      z4h-backward-kill-word = [ "<Ctrl>" "Backspace" ];
      undo = [ "<Ctrl>" "Z" ];
      redo = [ "<Ctrl>" "Y" ];
    };
  };

  programs.zsh.initBlocks.disable-termios-ctrl-s = ''
    # disable Ctrl+S handling from the terminal driver (termios)
    # (this is particularly useful because we bind Ctrl+S to z4h-stash-buffer,
    # but also because i've personally never done)
    stty -ixon
  '';
}
