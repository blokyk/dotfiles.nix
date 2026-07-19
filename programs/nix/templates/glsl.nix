let
  pins = import ./npins {};
  pkgs = import pins.nixpkgs {};
  vscode-ext-hook = pkgs.callPackage pins.vscode-ext-hook.outPath {};
in
with pkgs;
mkShell {
  packages = [
    glsl_analyzer
    glslang

    vscode-ext-hook
  ];

  vscodeExtensions =
    let
      nixExts = with vscode-extensions; [
      ];

      mktplcExts = vscode-utils.extensionsFromVscodeMarketplace [
        # fixme: this extension should bundle glslangValidator (from pkgs.glslang)
        { name = "vscode-glsllint"; publisher = "dtoplak"; version = "latest"; sha256 = ""; }
        # fixme: this extension should bundle glsl_analyzer
        { name = "glsl-analyzer"; publisher = "nolanderc"; version = "latest"; sha256 = ""; }
      ];
    in
     nixExts ++ mktplcExts;
}
