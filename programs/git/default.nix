{ lib, pkgs, ... }: {
  imports = [ ./shell-aliases.nix ];

  programs.git = {
    enable = true;

    settings.alias = {
      unstage = "restore --staged";

      # show/checkout last branches
      lb =
        "!git reflog show --pretty=format:'%gs ~ %gd' --date=relative | " +
        "grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | " +
        "awk -F' ~ HEAD@{' '{printf(\"  \\x1b[33m%s: \\x1b[0m\\x1b[1m %s\\x1b[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
      clb = ''!git checkout "$(git lb | ${lib.getExe pkgs.fzf} --ansi | cut -d':' -f2 | tr -d ' ')"'';
    };

    lfs.enable = true;
    settings.filter.lfs.required = true;

    settings = {
      user = {
        name = "blokyk";
        email = "courvoisier.zoe@gmail.com";
      };

      core = {
        autocrlf = false;
        # pager = less -FRX # overridden by delta git integration
        filemode = false;
        # note: this should contain stuff that is completely personal,
        #       and that is unlikely to show up in other user's setup.
        #       since these settings won't be replicated in the repo's
        #       gitignore, this should NOT include common things like `.vscode`
        excludesFile = builtins.toFile "global-gitignore" ''
          # nano swap/lock files
          *.swp

          *.old
          *.bkp
        '';
      };

      init.defaultBranch = "main";

      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autostash = true;  # always stash before starting a rebase, and then pop it when the rebase is done
      rebase.updateRefs = true; # when rebasing a branch that is the base of other branches, update the commits these branches are based on

      rerere.enabled = true;

      submodule.recurse = true;

      color.ui = true;

      diff = {
        algorithm = "histogram";
        colorMoved = "default";
        #tool = "vscode";
      };

      difftool = {
        prompt = false;

        meld.cmd = ''meld "$LOCAL" "$REMOTE"'';
        vscode.cmd = ''code --wait --diff "$LOCAL" "$REMOTE"'';
      };

      # merge.tool = "vscode";
      # mergetool.vscode.cmd = ''code --wait "$MERGED"'';

      advice = {
        detachedHead = false;
      };
    };
  };
}
