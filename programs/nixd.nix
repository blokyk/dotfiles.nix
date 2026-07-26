{ lib, pkgs, ... }: {
  home.packages = [ pkgs.nixd ];

  nixpkgs.overlays = [(
    final: prev: {
      nixd = final.mkAlias {
        pkg = prev.nixd;
        flags = [ "-log=error" ];
        # wrap nixd with systemd-run to ensure that it doesn't consume gigantic
        # amounts of ressources when it inevitably glitches out
        preexec = lib.getExe (final.mkAlias {
          # todo: make this kind of wrapper into a module with options,
          #       so i don't have to look at the man/tldr page everytime
          pkg = pkgs.systemd;
          baseCmd = "systemd-run";
          flags = [
            "--property" "MemoryHigh=4G"
            "--property" "MemoryMax=6G"
            "--property" "CPUQuota=50%"

            "--user" # use the user's systemd, not the system's one (which requires root)
            "--scope" # make sure the program inherit the caller's environment

            # "--pipe" "--pty" # connect stdin/stdout/stderr correctly
            "--same-dir" # run the program in the current working directory
            # "--property" "Type=exec" # make sure the program/service terminated with exit code 0
            # "--wait" # only exit once the service has terminated
            "--quiet" # don't print additional info while running
            "--collect" # unload unit after termination
          ];
        });
      };
    }
  )];

}
