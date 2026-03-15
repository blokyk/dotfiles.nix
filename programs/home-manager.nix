{ config, lib, pkgs, ... }:
let
  dag = lib.hm.dag;
  hm = config.programs.home-manager;
in {
  options.programs.home-manager.report-changes = {
    enable = lib.mkEnableOption "report-changes";
    askForConfirmation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to ask the user for confirmation after displaying the diff.
      '';
    };
  };

  config.home.activation = lib.mkIf (hm.report-changes.enable) {
    # use `lix-diff` to check and show the differences from the previous hm generation
    reportChanges = dag.entryBefore [ "writeBoundary" ] ''
      __do_diff() {
        run ${lib.getExe pkgs.lix-diff} --no-header --return \
          $(readlink --canonicalize "''${oldGenPath:-$genProfilePath}") \
          $(readlink --canonicalize "$newGenPath")
      }

      _iNote "Differences from the previous generation:"

      # the activation script has `set errexit`, but we expect errors here,
      # so use the retcode of diff to choose the value of the variable.
      #
      # lix-diff returns 1 on no-diff, 0 on differences, don't ask me why /shrug
      # therefore, we have to invert it
      __do_diff && __had_diffs=true || __had_diffs=false

      if ! "$__had_diffs"; then
        verboseEcho "no surface-level differences between current gen and next one"
      fi
    '';

    # if there are differences, ask the user to confirm they're okay with them
    confirmChanges = lib.mkIf (hm.report-changes.askForConfirmation) (
      dag.entryBetween [ "writeBoundary" ] [ "reportChanges" ] ''
        # only ask if there ARE differences
        if "$__had_diffs"; then
          # only ask if stdin is a tty; otherwise, just assume yes
          if [ -t 0 ] && [ "X''${TERM:-}" != "Xdumb" ]; then
            echo -n "Proceed with the activation? (Y/n) "
            if [[ "''${DRY_RUN:-0}" = "0" ]]; then
              read -r __ask_diff_res
              case "$__ask_diff_res" in
                [nN][oO]|[nN])
                  _iError "Activation cancelled"
                  verboseEcho "user rejected the activation diff, exiting"
                  exit 1
                ;;
                *)
                  verboseEcho "user accepted the activation diff, proceeding"
                ;;
              esac
            fi
          else
            verboseEcho "stdin is not a tty, not asking the user confirmation"
          fi
        fi
      ''
    );
  };
}
