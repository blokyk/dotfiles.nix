{ ... }:
let
  valence = { lat = 44.93; long = 4.89; };
in {
  services.redshift = {
    enable = true;
    tray = true;

    temperature = {
      # day = 5500;
      night = 2500;
    };

    provider = "manual";
    latitude = valence.lat;
    longitude = valence.long;

    settings.redshift.transition = 1;
  };
}