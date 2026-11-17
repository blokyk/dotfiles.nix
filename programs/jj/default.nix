{ ... }: {
  imports = [ ./jj-check.nix ];

  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "blokyk";
        email = "courvoisier.zoe@gmail.com";
      };

      ui.diff-formatter = ":git";

      # never push commits that start with `private:` or `wip:`
      git.private-commits = "description('private:*') | description('wip:*')";
    };
  };
}
