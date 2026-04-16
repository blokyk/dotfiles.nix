{ ... }: {
  home.shellAliases = {
    gco = "git checkout";
    gs = "git status";
    gsh = "git show";

    # alias to a git alias using another git alias to checkout @_@
    gclb = "git clb";

    gl = "git log";
    glg = "git log --oneline --all --graph";
    glo = "git log --oneline --decorate";
    gls = "git log --stat";

    gc = "git commit --verbose";
    "gc!" ="git commit --verbose --amend --no-edit";
    "gc!!" ="git commit --verbose --amend";

    gb = "git checkout -b";
    gbd = "git branch -d";
    gbD = "git branch -D";
    "gbd!" ="gbD";
    gbmv = "git branch --move";

    ga = "git add";
    "ga." ="git add .";

    grbi = "git rebase -i";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";

    gr = "git reset --soft";
    "gr!" ="git reset --hard";

    gcp = "git cherry-pick";

    # todo: make gwip/gunwip commands (kinda like omz's git plugin, but closer to what i used to do / more flexible)
  };
}
