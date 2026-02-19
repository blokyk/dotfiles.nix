{ ... }:
let
  valence = { lat = 44.93; long = 4.89; };
  porto = { lat = 41.1579; long = 8.6291; };
in {
  services.redshift = {
    enable = true;
    tray = true;

    temperature = {
      # day = 5500;
      night = 2500;
    };

    provider = "manual";
    latitude = porto.lat;
    longitude = porto.long;

    settings.redshift.transition = 1;
  };
}