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
    #./features/productivity
    ./features/pass
    ./features/nvim
    ./features/cli
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.
}
