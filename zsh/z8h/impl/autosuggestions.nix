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
    programs.zsh.initBlocks = lib.mkIf cfg.enable {
      configure-autosuggestion-widgets = lib.hm.dag.entryAfter [ "z4h-prelude" "autosuggestion" ] ''
        # typeset -g ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()
        # typeset -g ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
        #   z4h-fzf-history
        #   z4h-down-prefix-global
        #   z4h-down-prefix-local
        #   z4h-up-prefix-global
        #   z4h-up-prefix-local
        # )
        # if (( _z4h_use[zsh-history-substring-search] )); then
        #   ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
        #     z4h-down-substring-global
        #     z4h-down-substring-local
        #     z4h-up-substring-global
        #     z4h-up-substring-local
        #   )
        # fi
        # typeset -g ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
        #   emacs-forward-word
        #   forward-word
        #   vi-find-next-char
        #   vi-find-next-char-skip
        #   vi-forward-blank-word
        #   vi-forward-blank-word-end
        #   vi-forward-word
        #   vi-forward-word-end
        #   z4h-forward-word
        #   z4h-forward-zword
        # )
        # typeset -g ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
        #   z4h-end-of-buffer
        # )

        # _zsh_autosuggest_widget_modify() {
        #   _zsh_autosuggest_invoke_original_widget "$@"
        #   local -i retval=$?
        #   [[ -z $POSTDISPLAY ]] || region_highlight[-1]=()
        #   -z4h-autosuggest-fetch
        #   return retval
        # }

        # _zsh_autosuggest_widget_fetch() {
        #   [[ -z $POSTDISPLAY ]] || region_highlight[-1]=()
        #   -z4h-autosuggest-fetch
        # }

        # _zsh_autosuggest_widget_suggest() {
        #   [[ -z $BUFFER || $CONTEXT != start ]] && return
        #   [[ -z $POSTDISPLAY ]] || region_highlight[-1]=()
        #   POSTDISPLAY=''${1-}
        #   typeset -g _z4h_autosuggest_buffer="$BUFFER"
        #   typeset -g _z4h_autosuggestion="''${BUFFER}''${POSTDISPLAY}"
        #   if [[ -n $POSTDISPLAY ]]; then
        #     region_highlight+=(
        #       "''${#BUFFER} $((''${#BUFFER} + ''${#POSTDISPLAY})) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
        #   fi
        # }

        # _zsh_autosuggest_widget_enable() {
        #   (( ''${+_ZSH_AUTOSUGGEST_DISABLED} )) || return 0
        #   unset _ZSH_AUTOSUGGEST_DISABLED
        #   _zsh_autosuggest_widget_fetch
        # }

        # _zsh_autosuggest_widget_disable() {
        #   (( ''${+_ZSH_AUTOSUGGEST_DISABLED} )) && return
        #   typeset -g _ZSH_AUTOSUGGEST_DISABLED
        #   [[ -z $POSTDISPLAY ]] || region_highlight[-1]=()
        #   unset POSTDISPLAY _z4h_autosuggest_buffer _z4h_autosuggestion
        # }

        # _zsh_autosuggest_widget_toggle() {
        #   if (( ''${+_ZSH_AUTOSUGGEST_DISABLED} )); then
        #     _zsh_autosuggest_widget_enable
        #   else
        #     _zsh_autosuggest_widget_disable
        #   fi
        # }
      '';
    };
  };
}
