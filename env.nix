{ config, lib, ... }:
let
  HOME = config.home.homeDirectory;
  zdotdir = lib.removePrefix "${HOME}/" config.programs.zsh.dotDir;

  resetEnvScript = ''
    # make sure HM session variables are always sourced,
    # not just on graphical environment start
    # (but only if we're not in a nix-shell, cause in that case we want to prioritize the shell's env)
    if [[ "''${IN_NIX_SHELL:-}" = "" ]]; then
      unset __HM_SESS_VARS_SOURCED
      unset __HM_ZSH_SESS_VARS_SOURCED
    fi
  '';
in {
  # ! this is bad but it's not my fault home-manager is bad
  home.file = {
    "${zdotdir}/.zprofile".text = lib.mkBefore resetEnvScript;
    "${zdotdir}/.zshenv".text = lib.mkBefore resetEnvScript;
  };

  home.sessionVariables = {
    TERM = "xterm-256color";
    ANDROID_HOME = config.home.homeDirectory + "/Android/Sdk";
    DOTNET_CLI_TELEMETRY_OPTOUT = true;
  };

  xdg.enable = true;
  xdg.cacheHome  = "${HOME}/.cache";
  xdg.dataHome   = "${HOME}/.local/share";
  xdg.stateHome  = "${HOME}/.local/state";
  xdg.binHome    = "${HOME}/.local/bin";
  xdg.configHome = "${HOME}/.config";

  xdg.systemDirs.data = lib.mkAfter [
    "/usr/share/ubuntu"
    "/usr/share/gnome"
    "/usr/local/share"
    "/usr/share"
    "/var/lib/snapd/desktop"
    "/var/lib/flatpak/exports/share"
    "/nix/var/nix/profiles/default/share"
    "${HOME}/.local/share/flatpak/exports/share"
    "${HOME}/.nix-profile/share"
  ];
}
