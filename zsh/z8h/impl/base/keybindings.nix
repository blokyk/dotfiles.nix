{ lib, ... }: {
  programs.z8h.keybindings = {
    # navigation
    backward-char = [ "Left" ];
    forward-char  = [ "Right" ];
    beginning-of-line = [ "Home" ];
    end-of-line = [ "End" ];
    z4h-beginning-of-line = lib.mkMerge [
      [ "<Ctrl>" "Home" ]
      [ "<Alt>"  "Home"]
    ];
    z4h-end-of-line = lib.mkMerge [
      [ "<Ctrl>" "End" ]
      [ "<Alt>"  "End"]
    ];

    z4h-forward-word  = [ "<Ctrl>" "Right" ];
    z4h-backward-word = [ "<Ctrl>" "Left" ];
    z4h-forward-zword  = [ "<Ctrl>" "<Shift>" "Right" ];
    z4h-backward-zword = [ "<Ctrl>" "<Shift>" "Left" ];

    delete-char = lib.mkMerge [
      [ "<Ctrl>" "D" ]
      [ "Delete" ]
    ];
    z4h-kill-word = lib.mkMerge [
      [ "<Alt>" "D" ]
      [ "<Ctrl>" "Delete" ]
      [ "<Alt>"  "Delete" ]
    ];
    z4h-backward-kill-word = lib.mkMerge [
      [ "<Ctrl>" "W" ]
      [ "<Alt>"  "Backspace" ]
      [ "<Ctrl>" "<Alt>" "Backspace" ]
    ];
    z4h-kill-zword = [ "<Ctrl>" "<Shift>" "Delete" ];

    # todo: add z8h.zsh-history-substring-search
    #   if (( _z4h_use[zsh-history-substring-search] )); then
    #     # Move cursor one line up or fetch the previous command from LOCAL history.
    #     bindkey '^P'      z4h-up-substring-local         # ctrl+p
    #     bindkey '^[[A'    z4h-up-substring-local         # up
    #     # Move cursor one line down or fetch the next command from LOCAL history.
    #     bindkey   '^N'    z4h-down-substring-local       # ctrl+n
    #     bindkey   '^[[B'  z4h-down-substring-local       # down
    #   else
    #     # Move cursor one line up or fetch the previous command from LOCAL history.
    #     bindkey '^P'      z4h-up-prefix-local            # ctrl+p
    #     bindkey '^[[A'    z4h-up-prefix-local            # up
    #     # Move cursor one line down or fetch the next command from LOCAL history.
    #     bindkey '^N'      z4h-down-prefix-local          # ctrl+n
    #     bindkey '^[[B'    z4h-down-prefix-local          # down
    #   fi

    z4h-up-prefix-global = [ "<Control>" "Up" ];
    z4h-down-prefix-global = [ "<Control>" "Down" ];
  };
}
