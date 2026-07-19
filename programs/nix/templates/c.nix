let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage vscode-ext-hook.outPath {};
in
with pkgs;
mkShell {
  packages = [
    # note: no need to explicitly add stuff like make and gcc since mkShell is an stdenv

    clangd
    lldb

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
        # fixme: this extension should bundle clangd
        llvm-vs-code-extensions.vscode-clangd
        # fixme: this extension should bundle lldb
        llvm-vs-code-extensions.lldb-dap
        ms-vscode.makefile-tools
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
      ];
    in
     nixExts ++ mktplcExts;
}
