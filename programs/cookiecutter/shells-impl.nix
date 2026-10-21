{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  cfg = config.nix.devshells;
in {
  options.nix.devshells = mkOption {
    example = {
      flutter = {
        packages = [ "flutter" ];
        nixExts = [
          "dart-code.dart-code"
          "dart-code.flutter"
        ];
        mktplcExts = [
          "aziznal.dart-import-sorter"
        ];
      };
    };

    type = types.attrsOf (types.submodule {
      options = {
        packages = mkOption {
          description = ''
            List of nix expressions for each package to include in the shell (assuming a preceding `with pkgs;`)
          '';
          type = types.listOf types.str;
          example = [ "clangd" "rustc" "python3.withPackage (p: with p; [])" ];
        };

        nixExts = mkOption {
          description = ''
            List of extensions from `pkgs.vscode-extensions` to include in the shell
          '';
          type = types.listOf types.str;
          example = [ "dart-code.flutter" ];
        };

        mktplcExts = mkOption {
          description = ''
            List of extensions from the market to include in the shell
          '';
          type = types.listOf (types.strMatching "[[:alpha:][:digit:]-]+\\.[[:alpha:][:digit:]-]+");
          example = [
            "aziznal.dart-import-sorter"
            "ms-python.python"
          ];
        };

        useCC = mkOption {
          description = ''
            Whether the shell should include a C compiler toolchain (use mkShell) or not (use mkShellNoCC).
          '';
          type = types.bool;
          default = false;
        };
      };
    });
  };

  config = {
    programs.cookiecutter.cutters = builtins.mapAttrs (
        name: spec: pkgs.mkShellCutter {
          inherit name;
          devshell = builtins.toFile name (pkgs.mkShellText spec);
        }
      ) cfg;
  };
}
