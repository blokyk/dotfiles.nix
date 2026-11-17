{ lib, pkgs, ... }:
let
  check = {
    doc = "Run pre-commit hooks on a given revset";
    definition = [ "util" "exec" "--" check-wrapper ];
  };

  check-wrapper = pkgs.writeShellScript "jj-check-wrapper" ''
    # capture the state *before* the checks runs
    pre_fix_op="$(jj op log -G -n 1 -T id)"

    # run the check, and never fail (such that we always capture every change,
    # which we'll rollback right afterwards anyway)
    jj --color=always run --root --clean "$@" -- \
      ${lib.getExe pkgs.bash} -c '${run-pre-commit} || true; echo';

    # capture the state *after* the checks ran
    post_fix_op="$(jj op log -Gn 1 -T id)"

    # if files were modified by this check, the op ids will be different
    if [[ "$pre_fix_op" != "$post_fix_op" ]]; then
      # restore the repo to before the fix
      jj op restore "$pre_fix_op"

      # then tell the user how to apply the modified version
      echo
      echo -e '\e[1;33mWarn:\e[39m Files were modified by this check. Repo state has been reverted to previous state.\e[0m'
      echo -e '\e[1;34mInfo:\e[0m Use `jj op show '"''${post_fix_op:0:12}"'` to preview them.'
      echo -e              '      and \e[1m`jj op restore '"''${post_fix_op:0:12}"'`\e[0m to accept them.'
    else
      echo
      echo -e '\e[1mEverything \e[32mOK!\e[0m \e[2mwell done~\e[0m'
    fi
  '';

  run-pre-commit =
    let
      realpath = lib.getExe' pkgs.coreutils "realpath";
      sed = lib.getExe pkgs.gnused;
      xargs = lib.getExe' pkgs.findutils "xargs";
      # note: we deliberatly don't use pkgs.pre-commit to avoid paying the closure
      # price just for one or two repos
      pre-commit = "pre-commit";
    in pkgs.writeShellScript "jj-run-pre-commit" ''
      set -euo pipefail

      # show the change currently being checked
      jj --color=always log -r "$JJ_CHANGE_ID" --no-graph -T '"checking " ++ change_id.shortest(8) ++ label("description placeholder", " (" ++ description.first_line() ++ ")") ++ "\n"'

      # in the list of files that `jj diff` will give us, each path will be the one
      # in the "real" working tree, instead of this temporary copy.
      # however, we want `pre-commit` to operate on the version in the temp copy,
      # not the real tree, so we have to "transplant" these paths from the latter
      # to the former.
      # the paths output by `jj diff` are relative to the current directory, so
      # they'll start with a bunch of `../../` segments. to transplant these paths,
      # we can just remove this relative prefix and that's it.
      # to compute that prefix, we just get the path of the real tree's root relative
      # to the current temp copy
      rel_prefix="$(${realpath} "$(jj root)" --relative-to ./.)/"

      # display the diff but strip out the unnecessary relative part
      jj --color=always diff --summary -r "$JJ_CHANGE_ID" | ${sed} "s@$rel_prefix@@"
      echo "-------------------------------------------------------------------------------"

      # FINALLY actually invoke pre-commit on the various files modified by this change,
      # making sure to transplant them, and using xargs to properly handle filenames with spaces
      jj diff --name-only -r "$JJ_CHANGE_ID" | ${sed} "s@$rel_prefix@@" | ${xargs} ${pre-commit} run \
        --config="$(jj root)/.pre-commit-config.yaml" \
        --color=always \
        --hook-stage=pre-commit --files
    '';
in {
  programs.jujutsu.settings.aliases = { inherit check; };
}
