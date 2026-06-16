{ ... }: {
  home.sessionPath = [
    "/run/wrappers/bin" # wrappers have a higher priority (i.e. override) system binaries
    "/run/system-manager/sw/bin"
  ];
}
