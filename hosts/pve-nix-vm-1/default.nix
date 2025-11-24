{inputs, modulesPath, ...}: {
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/optional/acme.nix
    ../common/optional/nginx.nix

    ../common/global
    ../common/users/mrhappy200
    ../common/optional/tailscale-exit-node.nix
    inputs.disko.nixosModules.disko
#    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

# 1. Add support for your filesystem (Btrfs)
  boot.supportedFilesystems = [ "btrfs" ];

  # 2. Add the required kernel modules for the disk controller and btrfs
  boot.initrd.availableKernelModules = [
    # Disk controller for QEMU/VirtIO
    #"virtio_blk"
    #"virtio_pci"
    # Filesystem
    "btrfs"
  ];

  nixpkgs.hostPlatform.system = "x86_64-linux";

  networking = {
    hostName = "pve-nix-vm-1";
    useDHCP = true;
    #dhcpcd.IPv6rs = true;
    #interfaces.ens3 = {
    #  useDHCP = true;
    #  wakeOnLan.enable = true;
    #  #      ipv4.addresses = [
    #  #        {
    #  #          address = "216.238.110.82";
    #  #          prefixLength = 23;
    #  #        }
    #  #      ];
    #  #      ipv6.addresses = [
    #  #        {
    #  #          address = "2001:19f0:b800:1bf8::1";
    #  #          prefixLength = 64;
    #  #        }
    #  #      ];
    #};
  };
  system.stateVersion = "22.05";
}
