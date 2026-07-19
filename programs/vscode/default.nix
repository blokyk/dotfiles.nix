{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  imports = [ ./extensions.nix ];

  nixpkgs.config.allowUnfreePackages = [
    "code"
    "vscode"
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

    profiles.default = {
      # we use writable symlinks instead of standard nix files because it'd be
      # annoying to have to constantly do a `home-manager switch` just to try
      # out keybindings or settings.
      # since they are symlinks, if they are modified in vscode, they'll show
      # up as dirty here so we still get traceability
      # todo: manage more of the config directly in nix, and then merge it
      # onto a writable json file that is linked with `mkOutOfStoreSymlink`
      keybindings = mkOutOfStoreSymlink ./keybindings.json;
      userSettings = mkOutOfStoreSymlink ./settings.json;

      languageSnippets = {
        nix = import ./nix-snippets.nix;
      };
    };
  };
}
