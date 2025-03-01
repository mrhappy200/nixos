{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/desktop/calibre.nix
    ./features/desktop/slack.nix
    ./features/desktop/mpd.nix
    ./features/productivity
    ./features/pass
    ./features/games
    ./features/cli
  ];

  home.packages = [pkgs.gqrx inputs.myNvim.packages.x86_64-linux.default];

  monitors = [
    {
      name = "eDP-1";
      width = 1366;
      height = 768;
      x = 1280;
      y = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1280;
      height = 720;
      x = 0;
      y = 0;
      workspace = "2";
    }
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 2646;
      y = 0;
      workspace = "3";
    }
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
