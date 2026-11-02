{ pkgs, ... }:
pkgs.ringboard.overrideAttrs (prev: {
  cargoPatches = [
    ./on-primary-monitor.patch
    ./on-primary-monitor.lock.patch
  ];

  cargoHash = "sha256-T65TxIes0171uDxDE72SnFeRVAgw5FR2z6yTcmH3Z6k=";

  buildInputs = (prev.buildInputs or []) ++ [ pkgs.libxcb ];
})
