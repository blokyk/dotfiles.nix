{ lib, ... }:
let
  changeExtUUID =
    oldUUID: newUUID: pkgset:
      pkgset // {
        ${newUUID} = pkgset.${oldUUID}.overrideAttrs (
          finalAttrs: prevAttrs: {
            installPhase = ''
              runHook preInstall
              mkdir -p $out/share/gnome-shell/extensions/
              cp -r -T . $out/share/gnome-shell/extensions/${newUUID}
              runHook postInstall
            '';
          }
        );
      };
in {
  # (mkAfter to ensure it comes after the original `gnomeCurrentExtensions` declaration)
  nixpkgs.overlays = lib.mkAfter [(
    finalPkgs: prevPkgs: {
      # despite being the same exact extensions, the system-installed ubuntu extensions
      # have a different UUID, so on ubuntu distro gnome will see two "different" extensions
      # and enable them both, creating conflicts
      gnomeCurrentExtensions =
        lib.pipe prevPkgs.gnomeCurrentExtensions [
          (changeExtUUID
            "tiling-assistant@leleat-on-github"
            "tiling-assistant@ubuntu.com"
          )
        ];
    }
  )];
}
