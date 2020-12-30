{ ... }:
{
  services.redshift = {
    enable = true;
    provider = "manual";

    latitude = "52.520008";
    longitude = "13.404954";

    brightness = {
      night = "0.3";
      day = "1.0";
    };

    temperature = {
      night = 2700;
      day = 5500;
    };
  };
}
