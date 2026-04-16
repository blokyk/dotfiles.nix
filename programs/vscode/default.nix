{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "code"
    "vscode"
    "vscode-extension-MS-python-vscode-pylance"
  ];

  programs.vscode = {
    enable = true;
    # todo: switch to vscodium-fhs
    # for some reason, using the nix package completely bugs out
    # (and even crashed gnome a few times while testing)
    /*package =
      let
        mkPrefixOpt = dir: "--prefix XDG_DATA_DIRS ':' ${dir}";
        patched-vscode = pkgs.vscode.overrideAttrs (final: prev: {
          preFixup = prev.preFixup + ''
            gappsWrapperArgs+=(
              ${lib.concatMapStringsSep "\n" mkPrefixOpt config.xdg.systemDirs.data}
            )
          '';
        });
      in
        patched-vscode.fhs;*/
    package = null;
    pname = "vscode";

    profiles.default = {
      extensions =
        let
          nixpkgsExtensions = with pkgs.vscode-extensions; [
            # suggestions and go-to for path-like things, mainly files and folders
            christian-kohler.path-intellisense
            # nixd-compatible extension
            jnoortheen.nix-ide
            # clangd, a c++ lsp
            llvm-vs-code-extensions.vscode-clangd
            # python syntax highlighting + language server
            ms-python.python
            ms-python.vscode-pylance
            # bash script checking
            timonwong.shellcheck

            # highlight trailing spaces at the end of lines
            shardulm94.trailing-spaces
            # change the window color of each new folder/workspace
            # todo: not packaged #stuart.unique-window-colors

            # one dark pro theme
            zhuangtongfa.material-theme
            # normal vscode icons w/ folder icons instead of '>'
            # todo: not packaged #sabaken.seti-minimal-folder
            # todo: not packaged #adam-bender.vscode-oldicons
          ];

          marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # find 'todo:' and 'fixme:' comments and displays them by-file
            { name = "todo-tree"; publisher = "gruntfuggly"; version = "0.0.226"; sha256 = "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn";  }

            # remote ssh stuff
            { name = "remote-ssh"; publisher = "ms-vscode-remote"; version = "0.122.0"; sha256 = "162hln17fkpnacw98l6igfzsg95azsmaw41kbnv282bcg0xq353a";  }
            { name = "remote-ssh-edit"; publisher = "ms-vscode-remote"; version = "0.87.0"; sha256 = "1qqsnzn9z11jr72n7cl0ab6i9mv49c0ijcp699zbglv5092gmrf9";  }
            { name = "remote-explorer"; publisher = "ms-vscode"; version = "0.5.0"; sha256 = "1gws544frhss2x2i7s50ipaalcz6ai2688ykcgvinxsxv9x2gnq4";  }

            # add a unique accent color to each window based on workspace path
            { name = "unique-window-colors"; publisher = "stuart"; version = "1.2.9"; sha256 = "0lbjnihxaznm2r6zh6a1mz96h89430ba6cr4k43qhpk2gpk3d2vf";  }

            { name = "vscode-oldicons"; publisher = "adam-bender"; version = "0.2.0"; sha256 = "0p7k0safirn9bf459d5m77igdx8qd6b3rs8j0ndgjyvjlw54wkhs";  }
            { name = "seti-minimal-folder"; publisher = "sabaken"; version = "1.0.3"; sha256 = "0ip528v3jpbyalpimw4myddmxfvr51bs5104lx5anad9icm37pm4";  }
          ];
      in
        nixpkgsExtensions ++ marketplaceExtensions;

      # we use writable symlinks instead of standard nix files because it'd be
      # annoying to have to constantly do a `home-manager switch` just to try
      # out keybindings or settings.
      # since they are symlinks, if they are modified in vscode, they'll show
      # up as dirty here so we still get traceability
      # todo: manage more of the config directly in nix, and then merge it
      # onto a writable json file that is linked with `mkOutOfStoreSymlink`
      keybindings = mkOutOfStoreSymlink ./keybindings.json;
      userSettings = mkOutOfStoreSymlink ./settings.json;
    };
  };
}
