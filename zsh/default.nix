{ config, ... }: {
  imports = [
    ./env.nix
    ./p10k.nix
    ./funcs.nix

    ./hooks-mod.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    enableVteIntegration = true;

    hooks = {
      chpwd = "__ls_after_cd";
    };

    # https://zsh.sourceforge.io/Doc/Release/Options.html
    setOptions = [
      # allow cd-ing into a directory by just typing its name as a command
      "auto_cd"

      # add the timestamp in front of the command in the history file
      "extended_history"

      # don't expand !! & co
      "no_bang_hist"

      # do not reread commands from the history file after the
      # shell session has started
      "no_share_history"

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
