{ pkgs, ... }: {
  home.packages = with pkgs; [
    # fancy alternative to cat(1)
    bat
    # simple, fast and user-friendly alternative to find
    fd
    # general-purpose command-line fuzzy finder
    fzf
    # recursively searches directories for a pattern
    ripgrep
    # 'tldr.sh' client written in rust
    tlrc
    # terminal file explorer
    yazi
  ];
}
