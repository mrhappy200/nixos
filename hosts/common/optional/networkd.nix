{ lib, ... }: {
  networking = {
    networking.dhcpcd.enable = lib.mkForce false;

  };
}
