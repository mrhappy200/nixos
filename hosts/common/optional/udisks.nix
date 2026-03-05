{ pkgs, ... }:
let
in
{
  services.udisks2 = {
    enable = true;
  };
  programs.gnome-disks.enable = true;
}
