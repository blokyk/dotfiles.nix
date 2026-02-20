{ pkgs, ... }: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      feature = "interactive";
      navigate = true; # activates diff navigation: use 'n' to jump forward and 'N' to jump backwards
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "Monokai Extended";
      line-numbers = true;
      side-by-side = true;
      wrap-max-lines = 3;
      whitespace-error-style = "22 reverse";
    };
  };

  programs.git = {
    enable = true;

    settings.alias = {
      unstage = "restore --staged";

      # show/checkout last branches
      lb =
        "!git reflog show --pretty=format format:'%gs ~ %gd' --date=relative | " +
        "grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | " +
        "awk -F' ~ HEAD@{' '{printf(\"  \\x1b[33m%s: \\x1b[0m\\x1b[1m %s\\x1b[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
      clb = ''!git checkout "$(git lb | ${pkgs.fzf} --ansi | cut -d':' -f2)"'';
    };

    lfs.enable = true;
    settings.filter.lfs = {
      process = "git-lfs filter-process";
      required = true;
      clean = "git-lfs clean -- %f";
      smudge = "git-lfs smudge -- %f";
    };

    settings = {
      user = {
        name = "blokyk";
        email = "courvoisier.zoe@gmail.com";
      };

      core = {
        autocrlf = false;
        # pager = less -FRX # overridden by delta git integration
        filemode = false;
      };

      init.defaultBranch = "main";

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