{ config, lib, ... }: {
  # fix newer home-manager using 'nix profile add' instead of 'nix profile install'
  home.activation.installPackages = lib.mkForce (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      nixProfileRemove home-manager-path
      if [[ -e ${config.home.profileDirectory}/manifest.json ]]; then
        run nix profile install ${config.home.path}
      else
        run nix-env -i ${config.home.path}
      fi
    ''
  );
}
