let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};

  ghc = pkgs.ghc.withPackages (hs-pkgs: with hs-pkgs; [
    # fixme: i wish we didn't use normal stack but instead used full nix-integration :(
    stack
  ]);
in
with pkgs;
mkShell {
  packages = [
    ghc
    haskell-language-server

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        haskell.haskell
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
        { name = "language-haskell"; publisher = "haskell"; version = "latest"; sha256 = ""; }
      ];
    in
     nixExts ++ mktplcExts;
}
