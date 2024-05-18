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
    ./features/nvim
    ./features/desktop/hyprland
    #./features/productivity
    ./features/pass
    ./features/games
    ./features/cli
  ];

  # monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 1366;
  #     height = 768;
  #     x = 1024;
  #     y = 1080;
  #     workspace = "1";
  #     primary = true;
  #   }
  #   {
  #     name = "HDMI-A-1";
  #     width = 1024;
  #     height = 600;
  #     x = 0;
  #     y = 1080;
  #     workspace = "2";
  #   }
  #   {
  #     name = "DP-1";
  #     width = 1920;
  #     height = 1080;
  #     x = 1024;
  #     y = 0;
  #     workspace = "3";
  #   }
  # ];

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
