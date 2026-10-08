{
  mkShellCutter,
  mkShellText,
}:
let
  shells = {
    "c.shell" = {
      useCC = true;
      packages = [
        "clangd"
        "lldb"
      ];
      nixExts = [
        # fixme: this extension should bundle clangd
        "llvm-vs-code-extensions.vscode-clangd"
        # fixme: this extension should bundle lldb
        "llvm-vs-code-extensions.lldb-dap"
        "ms-vscode.makefile-tools"
      ];
    };

    "dotnet.shell" = {
      packages = [ "dotnet-sdk "];
      nixExts = [
        "ms-dotnettools.csharp"
        "ms-dotnettools.csdevkit"
        "ms-dotnettools.vscode-dotnet-runtime"
        "redhat.vscode-xml"
      ];
    };

    "flutter.shell" = {
      packages = [ "flutter" ];
      nixExts = [
        "dart-code.dart-code"
        "dart-code.flutter"
      ];
      mktplcExts = [
        "aziznal.dart-import-sorter"
      ];
    };

    glsl = {
      packages = [
        "glsl_analyzer"
        "glslang"
      ];
      mktplcExts = [
        # fixme: this extension should bundle glslangValidator (from pkgs.glslang)
        "dtoplak.vscode-glsllint"
        # fixme: this extension should bundle glsl_analyzer
        "nolanderc.glsl-analyzer"
      ];
    };

    java = {
      packages = [ "jdk" ];
      nixExts = [
        "redhat.java"
        "vscjava.vscode-java-debug"
        "vscjava.vscode-gradle"
        "vscjava.vscode-java-dependency"
      ];
    };

    python = {
      packages = [
        "(python3.withPackages (p: with p; [ ]))"
      ];
      nixExts = [
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-python.debugpy"
      ];
    };
  };
in
  builtins.mapAttrs (
    name: spec: mkShellCutter {
      inherit name;
      devshell = builtins.toFile name (mkShellText spec);
    }
  ) shells
