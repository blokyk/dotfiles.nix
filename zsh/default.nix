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

      # make globs also match hidden files
      "glob_dots"

      # if a glob doesn't match any files, just leave it verbatim
      "no_nomatch"
    ];
  };
}
