{ pkgs, ... }:
pkgs.ringboard.overrideAttrs (prev: {
  cargoPatches = [
    ./on-primary-monitor.patch
    ./on-primary-monitor.lock.patch
  ];

  cargoHash = "sha256-hO67tlykfPjkc/v7JhJ4yIJMFSL/powWD7UDrBbfkII=";

  buildInputs = (prev.buildInputs or []) ++ [ pkgs.libxcb ];
})
