{pkgs, ...}: let
in {
  imports = [
    ./global
    #./features/desktop/hyprland-illogical-impulse-dots
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/rgb
    ./features/productivity
    ./features/pass
    ./features/games
  ];

  # Red
  wallpaper = pkgs.inputs.themes.wallpapers.landscape-river-birds;

  home.packages = with pkgs; [
    blender-hip
    kitty
  ];

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      workspace = "1";
      primary = true;
      position = "1024x0";
      refreshRate = 180;
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
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
