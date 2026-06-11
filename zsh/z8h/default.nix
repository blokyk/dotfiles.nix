{ ... }: {
  imports = [ ./impl ];

  programs.z8h = {
    enable = true;
    keybindings = {
      z4h-backward-kill-word = [ "<Ctrl>" "Backspace" ];
    };
  };
}
