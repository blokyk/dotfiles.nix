let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};

  python3 = pkgs.python3.withPackages (p: with p; [

  ]);
in
with pkgs;
mkShell {
  packages = [
    python3

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
      ];
    in
     nixExts ++ mktplcExts;
}
