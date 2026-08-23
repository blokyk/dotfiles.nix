{ lib, pkgs, ... }: {
  programs.gnome-shell.extensions = [{
    package = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "circular-battery-indicator";
      version = "3";

      src = <circular-battery-indicator>;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/gnome-shell/extensions/
        cp -r . -T "$out/share/gnome-shell/extensions/${finalAttrs.passthru.extensionUuid}";

        runHook postInstall
      '';

      meta = {
        description = "Displays a circular battery indicator";
        homepage = "https://github.com/RaphaelRochet/circular-battery-indicator";
        license = lib.licenses.gpl3Plus;
        platforms = pkgs.gnome-shell.meta.platforms;
      };

      passthru = {
        extensionPortalSlug = "circular-battery-indicator";
        extensionUuid = "circular-battery-indicator@RaphaelRochet";
        tests = {
          gnome-extensions = pkgs.nixosTests.gnome-extensions;
        };
      };
    });
  }];
}
