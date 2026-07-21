let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};
in
with pkgs;
mkShell {
  packages = [
    cargo
    rustc

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        rust-lang.rust-analyzer
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
      ];
    in
     nixExts ++ mktplcExts;
}
