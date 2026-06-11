{ config, lib, ... }:
let
  cfg = config.programs.z8h;
in {
  imports = [
    ./autosuggestions.nix
    ./keybindings.nix
    ./base
  ];

  options = {
    programs.z8h = {
      enable = lib.mkEnableOption "z8h, a z4h re-implementation";
    };
  };

  config = {
    programs.zsh.envExtra = lib.mkIf cfg.enable ''
      typeset -gr _z4h_opt='emulate -L zsh &&
        setopt typeset_silent pipe_fail extended_glob prompt_percent no_prompt_subst &&
        setopt no_prompt_bang no_bg_nice no_aliases'
    '';

    # push z4h stuff lower down in the zshrc
    programs.zsh.initBlocksPriority = lib.mkIf cfg.enable 2000;

    programs.zsh.initBlocks = lib.mkIf cfg.enable {
      zle-prelude = lib.hm.dag.entryAfter [ "z4h-prelude" ] ''
        PROMPT_EOL_MARK='%K{red} %k'    # mark the missing \n at the end of a comand output with a red block
        WORDCHARS='''                   # only alphanums make up words in word-based zle widgets
        ZLE_REMOVE_SUFFIX_CHARS='''     # don't eat space when typing '|' after a tab completion
        KEYTIMEOUT=20                   # wait for 200ms for the continuation of a key sequence
        zle_highlight=('paste:none')    # disable highlighting of text pasted into the command line
      '';
    };
  };
}
