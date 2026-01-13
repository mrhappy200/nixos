{ pkgs, config, ... }:
let
in
{
  imports = [
    ./global
    #./features/desktop/hyprland-illogical-impulse-dots
    ./features/desktop/hyprland
    ./features/desktop/wireless
    #./features/cli/mpd.nix
    ./features/productivity
    ./features/pass
    ./features/games
  ];

  # Red
  #wallpaper = pkgs.inputs.themes.wallpapers.cubist-crystal-brown-teal;

  home.packages = with pkgs; [
    #blender-hip
    kitty
    hyperhdr
    anki
    thonny
  ];

  home.persistence = {
    "/persist/".directories = [ ".local/share/Anki2" ];
  };

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      workspace = "1";
      primary = true;
      position = "1024x0";
      refreshRate = 180;
      bitdepth = 10;
    }
    {
      name = "HDMI-A-1";
      width = 1024;
      height = 600;
      position = "0x0";
      workspace = "2";
    }
  ];
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
