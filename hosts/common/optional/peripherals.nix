{ pkgs, ... }:
{
  services.hardware = {
    openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
      boot.kernelModules = ["uinput"];
  hardware = {
    uinput.enable = true; 
    keyboard.qmk.enable = true;
    opentabletdriver.enable = true;
  };
}
