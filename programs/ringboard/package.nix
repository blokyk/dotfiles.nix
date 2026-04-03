{ lib, pkgs, ... }:
let
  # allows us to use nightly rust
  fenix = import <fenix> {};
in
pkgs.ringboard.override {
  # incredibly cursed/hacky way to override buildRustPackage args,
  # since it doesn't have proper overrideAttrs support (much like
  # buildGoModule before nixos/nixpkgs#390220)
  rustPlatform = pkgs.rustPlatform.overrideScope (final: prev: {
    buildRustPackage = args:
      let
        buildRustPackage = prev.buildRustPackage.override { inherit (fenix.latest) cargo rustc; };
        overlay = final: prev: {
          cargoPatches = [
            ./on-primary-monitor.patch      # patch with code changes
            ./on-primary-monitor.lock.patch # patch with lockfile changes
          ];

          cargoHash = "sha256-8LJnnuVUMSUSHLAZxTq8IfTXDLDyOYvQUuoE51JlfGs";

          buildInputs = prev.buildInputs ++ [
            pkgs.libxcb
          ];
        };
        argsFn = if lib.isFunction args then args else (_: args);
      in
      buildRustPackage (lib.extends overlay argsFn);
  });
}
