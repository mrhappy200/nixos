{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dragon.nix
    ./firefox.nix
    ./kdeconnect.nix
    ./pavucontrol.nix
    ./playerctl.nix
  ];

  xdg.portal.enable = true;
}
