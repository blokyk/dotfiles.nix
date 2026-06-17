{ lib, pkgs, ... }: {
  systemd.user.services."xmousepaste" = {
    Unit = {
      Description = "Start xmousepaste at startup";
      After = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Type = "exec";
      Restart = "on-success";

      ExecStart = ''
        '${lib.getExe pkgs.xmousepasteblock}'
      '';
    };
  };
}
