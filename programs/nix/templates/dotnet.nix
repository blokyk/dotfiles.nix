let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};
in
with pkgs;
mkShell {
  packages = [
    dotnet-sdk

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        ms-dotnettools.vscode-dotnet-runtime
        redhat.vscode-xml
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
        { name = "net-compiler-developer-sdk"; publisher = "333fred"; version = "latest"; sha256 = ""; }
      ];
    in
     nixExts ++ mktplcExts;
}
