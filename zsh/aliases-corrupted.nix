{ ... }: {
  home.shellAliases = {
    ll = "ls -lha";
    la = "ls -A";

    cdtmp = "cd $(mktemp -d)";

    clipcopy = "xclip -sel clip";
    clippaste = "xclip -sel clip -o";

    csharp = "csharprepl";

    "lspci-tree" = "lspci -tv";

    ip = "ip -c";
    ssh = "ssh -C";

    # ...
    gedit = "gnome-text-editor";

    wdf = "watch -n .5 df -h";

    lg = "lazygit";

    syno-fr = "LANG=fr syno";

    # todo: add `compdef .f=git` somewhere to make sure completions work
    ".f" = "git --git-dir=$HOME/.dotfiles --work-tree=$HOME";

    lotus = "dotnet run --project src/CLI/Lotus.CLI.csproj -- ";
  };

  programs.zsh.completionInit = ''
    compdef .f=git
  '';
}
