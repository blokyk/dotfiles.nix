{ config, pkgs, ... }: {
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeCurrentExtensions."dash-to-dock@micxgx.gmail.com"; }
  ];

  assertions = [{
    assertion = !(builtins.elem
      "ubuntu-dock@ubuntu.com"
      config.dconf.settings."org/gnome/shell".enabled-extensions.value);
    message = ''
      The ubuntu-dock extension was enabled, but it conflicts with dash-to-dock.
      Please disable one of these two extensions.
    '';
  }];

  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [ "ubuntu-dock@ubuntu.com" ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      autohide = true; # show dock on mouse-over
      autohide-in-fullscreen = false; # don't show dock on mouse-over in fullscreen mode

      # only hide if the currently focused window hides it
      # (can also be one of "ALL_WINDOWS", "MAXIMIZED_WINDOWS", or "ALWAYS_ON_TOP")
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";

      # minimize open windows when clicking on the app icon
      click-action = "minimize";
      # open a new window of the app every time we middle-click it
      middle-click-action = "launch";
      # switch to the left or right workspace when scrolling on the dash
      scroll-action = "switch-workspace"; # one of "do-nothing", "cycle-windows", or "switch-workspace"
      shift-click-action = "cycle-windows";
      shift-middle-click-action = "launch";

      # don't show the "Show applications" button on the dock
      # (can still be opened by fast double-Win keypresses)
      show-show-apps-button = false;
      # don't show the trashcan icon
      show-trash = false;

      # only show windows from this workspace on the dash
      isolate-workspace = true;
      # which monitor to put the dock on, referred to by its connector name
      # (e.g. "eDP-1", also see xrandr)
      preferred-monitor-by-connector = "primary";

      # show icon/animation for urgent windows regardless of workspace
      workspace-agnostic-urgent-windows = true;

      dock-position = "BOTTOM";
      dash-opacity = 0.7;
      max-alpha = 0;
      min-alpha = 0;
      transparency-mode = "FIXED"; # constant transparency

      apply-custom-theme = true;
      custom-theme-shrink = false; # ???
      icon-size-fixed = false;
      running-indicator-style = "DOTS"; # one of "DEFAULT", "DOTS", "SQUARES", "DASHES", "SEGMENTED", "SOLID", "CILIORA", "METRO", "BINARY", or "DOT"

      # iirc, for some reason, this helps with a visual bug
      # where the dock duplicates on startup
      disable-overview-on-startup = false;
    };
  };
}
