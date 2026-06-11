{ config, lib, ... }: {
  imports = [(
    lib.modules.importApply ../misc/importNixFilesAndDirs.nix ./.
  )];

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

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
  };
}
