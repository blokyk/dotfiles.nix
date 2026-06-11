{ lib, ... }: {
  programs.z8h.keybindings = {
    # Move cursor one char backward.
    backward-char = [ "Left" ];
    # Move cursor one char forward.
    forward-char  = [ "Right" ];
    # Move cursor to the beginning of line.
    beginning-of-line = [ "Home" ];
    # Move cursor to the end of line.
    end-of-line = [ "End" ];
    # Move cursor to the beginning of buffer.
    z4h-beginning-of-line = (lib.mkMerge [
      [ "<Ctrl>" "Home" ]
      [ "<Alt>"  "Home"]
    ]);
    # Move cursor to the end of buffer.
    z4h-end-of-line = (lib.mkMerge [
      [ "<Ctrl>" "End" ]
      [ "<Alt>"  "End"]
    ]);

    # Move cursor one zsh word forward.
    z4h-forward-zword  = [ "<Ctrl>" "<Shift>" "Right" ];
    # Move cursor one zsh word backward.
    z4h-backward-zword = [ "<Ctrl>" "<Shift>" "Left" ];
    # Move cursor one word backward.
    z4h-forward-word  = (lib.mkMerge [
      [ "<Alt>" "f" ]
      [ "<Alt>" "F" ]
      [ "<Alt>" "Right" ]
      [ "<Ctrl>" "Right" ]
    ]);
    # Move cursor one word forward.
    z4h-backward-word = (lib.mkMerge [
      [ "<Alt>" "b" ]
      [ "<Alt>" "B" ]
      [ "<Alt>" "Left" ]
      [ "<Ctrl>" "Left" ]
    ]);

    # Delete the character under the cursor.
    delete-char = (lib.mkMerge [
      [ "<Ctrl>" "d" ]
      [ "<Ctrl>" "D" ]
      [ "Delete" ]
    ]);
    # Delete next word.
    z4h-kill-word = (lib.mkMerge [
      [ "<Alt>" "D" ]
      [ "<Ctrl>" "Delete" ]
      [ "<Alt>"  "Delete" ]
    ]);
    # Delete previous word.
    z4h-backward-kill-word = (lib.mkMerge [
      [ "<Ctrl>" "W" ]
      [ "<Alt>"  "Backspace" ]
      [ "<Ctrl>" "<Alt>" "Backspace" ]
    ]);
    # Delete next zsh word.
    z4h-kill-zword = [ "<Ctrl>" "<Shift>" "Delete" ];
    # Delete line before cursor.
    backward-kill-line = (lib.mkMerge [
      [ "<Alt>" "k" ]
      [ "<Alt>" "K" ]
    ]);
    # Delete all lines.
    kill-buffer = (lib.mkMerge [
      [ "<Alt>" "j" ]
      [ "<Alt>" "J" ]
    ]);

    # Push buffer to ephemeral history (won't be saved to HISTFILE) and delete all lines.
    z4h-stash-buffer = (lib.mkMerge [
      [ "<Alt>" "o" ]
      [ "<Alt>" "O" ]
    ]);

    # Accept autosuggestion.
    z4h-autosuggest-accept = (lib.mkMerge [
      [ "<Alt>" "m" ]
      [ "<Alt>" "M" ]
    ]);

    # Undo and redo.
    undo = [ "<Shift>" "Tab" ];
    redo = [ "<Alt>" "/" ];

    # Expand alias/glob/parameter.
    z4h-expand = [ "<Ctrl>" "Space" ];

    # Generic command completion.
    # fixme: right now, this doesn't work, preventing completions
    # z4h-fzf-complete = [ "Tab" ];

    # Show help for the command at cursor.
    run-help = (lib.mkMerge [
      [ "<Alt>" "h" ]
      [ "<Alt>" "H" ]
    ]);

    # Do nothing (better than printing '~').
    z4h-do-nothing = (lib.mkMerge [
      [ "PageUp" ]
      [ "PageDown" ]
    ]);

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

    # todo: prompt-at-bottom
    # if (( _z4h_can_save_restore_screen )) &&
    #    zstyle -T :z4h: prompt-at-bottom; then
    #   bindkey '^L'      z4h-clear-screen-soft-bottom   # ctrl+l
    #   bindkey '^[^L'    z4h-clear-screen-hard-bottom   # ctrl+alt+l
    # else
    #   bindkey '^L'      z4h-clear-screen-soft-top      # ctrl+l
    #   bindkey '^[^L'    z4h-clear-screen-hard-top      # ctrl+alt+l
    # fi

    # fixme: fzf-related stuff is broken
    # Command history.
    # z4h-fzf-history =  [ "<Ctrl>" "R" ];
    # Directory history.
    # z4h-fzf-dir-history = (lib.mkMerge [
    #   [ "<Alt>" "r" ]
    #   [ "<Alt>" "R" ]
    # ]);

    # Move cursor one line up or fetch the previous command from GLOBAL history.
    z4h-up-prefix-global = [ "<Control>" "Up" ];
    # Move cursor one line down or fetch the next command from GLOBAL history.
    z4h-down-prefix-global = [ "<Control>" "Down" ];

    # cd into the previous directory.
    z4h-cd-back = [ "<Shift>" "Left" ];
    # cd into the next directory.
    z4h-cd-forward = [ "<Shift>" "Right" ];
    # cd into the parent directory.
    z4h-cd-up = [ "<Shift>" "Up" ];
    # cd into a subdirectory (interactive).
    z4h-cd-down = [ "<Shift>" "Down" ];
  };
}
