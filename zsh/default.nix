{ config, lib, ... }: {
  imports = [(
    lib.modules.importApply ../misc/importNixFilesAndDirs.nix ./.
  )];

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    dirHashes = {
      "hm" = toString <self>;
      "hm-src" = toString <home-manager>;
      "z" = config.programs.zsh.dotDir;
    };

    # fixme: completion strategy doesn't work :(
    # autosuggestion.strategy = [ "history" "completion" ];

    enableVteIntegration = true;

    hooks = {
      chpwd = "__ls_after_cd";
    };

    history = {
      # add the timestamp in front of the command in the history file
      extended = true;
      # do not reread commands from the history file after the
      # shell session has started
      share = false;
      # delete old recorded entry if new entry is a duplicate
      ignoreAllDups = true;
    };

    # https://zsh.sourceforge.io/Doc/Release/Options.html
    setOptions = [
      # allow cd-ing into a directory by just typing its name as a command
      "auto_cd"

      # if the argument to `cd` is a variable, try to expand it and cd there
      "cdable_vars"

      # don't expand !! & co
      "no_bang_hist"

      # record how much time the command took to finish,
      # and append it immediately to the history file
      "inc_append_history_time"

      # make globs also match hidden files
      "glob_dots"

      # if a glob doesn't match any files, just leave it verbatim
      "no_nomatch"
    ];

    # For completions, try to:
    #   1. match directly
    #   2. match w/out case + treat '-' as '_' (and vice-versa)
    #   3. match a partial-word
    #   4. match a substring
    initBlocks.completion-matcher = lib.hm.dag.entryAfter [ "z4h-end" ] ''
      zstyle ':completion:*' matcher-list \
        ''' \
        'm:{a-zA-Z-_}={A-Za-z_-}' \
        'r:|=*' \
        'l:|=* r:|=*'
    '';

    initBlocks.completion-ls-colors = lib.hm.dag.entryAfter [ "z4h-end" ] ''
      # use the same colors as ls in the completion menu
      # (by splitting the LS_COLORS variable on every ':')
      zstyle ':completion:*' list-colors ''${(s(:))LS_COLORS}
    '';
  };
}
