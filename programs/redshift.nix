{ ... }:
let
  valence = { lat = 44.93; long = 4.89; };
in {
  services.redshift = {
    enable = true;
    tray = true;

    temperature = {
      day = 6500;
      night = 2500;
    };

    provider = "manual";
    latitude = valence.lat;
    longitude = valence.long;

    settings.redshift = {
      gamma-day = 1.0;
      transition = 1;
    };
  };
}
