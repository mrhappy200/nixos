{ pkgs, ... }:
{
  services.hardware = {
    openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
  hardware = {
    keyboard.qmk.enable = true;
    opentabletdriver.enable = true;
  };
}
