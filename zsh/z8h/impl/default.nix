{ config, lib, ... }:
let
  cfg = config.programs.z8h;
in {
  imports = [
    ./autosuggestions.nix
    ./fzf.nix
    ./keybindings.nix
    ./terminal.nix
    ./base
  ];

  options = {
    programs.z8h = {
      enable = lib.mkEnableOption "z8h, a z4h re-implementation";
    };
  };

  config = {
    programs.zsh.hooks = lib.mkIf cfg.enable {
      preexec = "-z4h-set-term-title-preexec";
      precmd = "-z4h-set-term-title-precmd";
    };

    # push z4h stuff lower down in the zshrc
    programs.zsh.initBlocksPriority = lib.mkIf cfg.enable 2000;

    programs.zsh.initBlocks = lib.mkIf cfg.enable {
      z4h-prelude = ''
        mkdir -p $XDG_DATA_HOME/z4h/stickycache
        mkdir -p $XDG_CACHE_HOME/z4h

        typeset -gr _z4h_opt='emulate -L zsh &&
          setopt typeset_silent pipe_fail extended_glob prompt_percent no_prompt_subst &&
          setopt no_prompt_bang no_bg_nice no_aliases'

        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        autoload -Uz run-help ''${^fpath}/run-help-^*.zwc(N:t)
      '';

      zle-prelude = lib.hm.dag.entryAfter [ "z4h-prelude" ] ''
        PROMPT_EOL_MARK='%K{red} %k'    # mark the missing \n at the end of a command output with a red block
        WORDCHARS='''                   # only alphanums make up words in word-based zle widgets
        ZLE_REMOVE_SUFFIX_CHARS='''     # don't eat space when typing '|' after a tab completion
        KEYTIMEOUT=20                   # wait for 200ms for the continuation of a key sequence
        zle_highlight=('paste:none')    # disable highlighting of text pasted into the command line
      '';

      z4h-init = lib.hm.dag.entryAfter [ "z4h-prelude" ] ''
      '';
    };
  };
}
