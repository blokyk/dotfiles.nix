{ config, ... }:
let
  templates = {
    # for (f in ./templates)
    #   if f is *.nix then
    #     mkShellCutter f (-> automatically creates a cutter for a devshell-type cutter (e.g. with npins hook and stuff))
    #   else if "$f/cutter.nix".exists? then
    #     pkgs.callPackage $f/cutter.nix {} (-> assume cutter.nix is a derivation for a cutter)
    #   else
    #     $f (-> assume normal/"raw" cookiecutter)
  };
in {
  imports = [
    ./shells-impl.nix
    ./shells.nix
  ];

  nixpkgs.overlays = [(
    self: super: {
      mkShellText = import ./mkShellText.nix;
      mkShellCutter = self.callPackage ./mkShellCutter {};
    }
  )];

  programs.cookiecutter = {
    enable = true;
    settings = {
      defaultContext = {};
      cookiecutters_dir = config.xdg.configHome + "/cookiecutters";
      replay_dir = config.xdg.cacheHome + "/cookiecutters/replay";
    };

    cutters = templates // {
      # todo: migrate stuff from nix/templates here
    };
  };
}
