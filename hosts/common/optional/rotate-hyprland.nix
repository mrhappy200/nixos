{ pkgs, ... }:
{
  hardware.sensor.iio.enable = true;
  # Technically this includes the above but you know
  programs.iio-hyprland.enable = true;
}
