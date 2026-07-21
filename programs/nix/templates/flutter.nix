let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};
in
with pkgs;
mkShell {
  packages = [
    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        dart-code.dart-code
        dart-code.flutter
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
        { name = "dart-import-sorter"; publisher = "aziznal"; version = "latest"; sha256 = ""; }
      ];
    in
     nixExts ++ mktplcExts;
}
