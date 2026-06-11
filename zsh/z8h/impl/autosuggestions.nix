# fixme: replace zstyle checks with config options

{ config, lib, ... }:
let
  cfg = config.programs.zsh.autosuggestion;
in {
  options = {
    programs.zsh.autosuggestion = {

    };
  };

  config = {
    programs.zsh.autosuggestion.enable = config.programs.z8h.enable;

    programs.zsh.initBlocks = lib.mkIf cfg.enable {
      configure-autosuggestion-widgets = lib.hm.dag.entryAfter [ "z4h-prelude" "autosuggestion" ] ''
        typeset -g ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()
        typeset -g ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
          z4h-fzf-history
          z4h-down-prefix-global
          z4h-down-prefix-local
          z4h-up-prefix-global
          z4h-up-prefix-local
        )
        if (( _z4h_use[zsh-history-substring-search] )); then
          ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
            z4h-down-substring-global
            z4h-down-substring-local
            z4h-up-substring-global
            z4h-up-substring-local
          )
        fi
        typeset -g ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
          emacs-forward-word
          forward-word
          vi-find-next-char
          vi-find-next-char-skip
          vi-forward-blank-word
          vi-forward-blank-word-end
          vi-forward-word
          vi-forward-word-end
          z4h-forward-word
          z4h-forward-zword
        )
        typeset -g ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
          z4h-end-of-buffer
        )

        if zstyle -T :z4h:autosuggestions forward-char accept; then
          ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(forward-char vi-forward-char)
        else
          ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char vi-forward-char)
        fi

        if zstyle -T :z4h:autosuggestions end-of-line accept; then
          ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(end-of-line vi-add-eol vi-end-of-line)
        else
          ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(end-of-line vi-add-eol vi-end-of-line)
        fi

        precmd_functions=(''${precmd_functions:#_zsh_autosuggest_start})

        local suggest_special=(
          $ZSH_AUTOSUGGEST_EXECUTE_WIDGETS
          $ZSH_AUTOSUGGEST_CLEAR_WIDGETS
          $ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS
          $ZSH_AUTOSUGGEST_ACCEPT_WIDGETS)
        typeset -g ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(''${''${(k)widgets}:|suggest_special})
        unset ZSH_AUTOSUGGEST_USE_ASYNC
        _zsh_autosuggest_start
      '';
    };
  };
}
