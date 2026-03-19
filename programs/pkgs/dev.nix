{ pkgs, ... }: {
  home.packages = with pkgs; [
    # github cli
    gh
    # command-line hex viewer
    hexyl
    # command-line benchmarking tool
    hyperfine
    # pretty diff between two derivations
    lix-diff
    # simple alternative to strace
    lurk
    # wrapper around nix-shell for debugging derivations
    nix-debug
    # prettify and summarize nix build output
    nix-output-monitor
    # tool for pinning and managing nix dependencies
    npins
    # explore dependency trees of derivations
    nix-tree
    # language server for nix
    nixd
    # official nix formatter
    nixfmt
    # dev tool for nixpkgs PR
    nixpkgs-review
    # graphics debugger
    renderdoc
    # quick code line counter
    tokei
  ];
}
