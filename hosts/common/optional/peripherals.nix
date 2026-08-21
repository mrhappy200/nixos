{ pkgs, ... }:
{

  boot.kernelModules = [ "uinput" ];
  hardware = {
    uinput.enable = true;
    keyboard.qmk.enable = true;
    opentabletdriver.enable = true;
  };
}
