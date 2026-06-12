{ ... }: {
  imports = [ ./impl ];

  programs.z8h = {
    enable = true;
    keybindings = {
      z4h-stash-buffer = [ "<Ctrl>" "S" ];
    };
  };

  programs.zsh.initBlocks.disable-termios-ctrl-s = ''
    # disable Ctrl+S handling from the terminal driver (termios)
    # (this is particularly because we bind Ctrl+S to z4h-stash-buffer)
    stty -ixon
  '';
}
