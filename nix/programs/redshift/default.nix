let
  redshift = {
    enable = true;
    provider = "geoclue2";

    brightness = {
      night = "0.3";
      day = "1.0";
    };

    temperature = {
      night = 2500;
      day = 5500;
    };
  };

  config = {
    services.redshift = redshift;
  };

in {
  inherit config;
}
