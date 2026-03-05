{ ... }:
{
  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings = {
      address = "euphrosyne";
      port = 5901;
      xkb_model = "chromebook";
      xkb_variant = "intl";
      xkb_options = "caps:super";
    };
  };

}
