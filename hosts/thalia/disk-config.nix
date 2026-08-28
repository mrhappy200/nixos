{
  config,
  lib,
  ...
}:
{
  config = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = lib.mkDefault "/dev/disk/by-id/nvme-WD_PC_SN740_SDDQNQD-256G-1001_22213R814871";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
                priority = 1;
              };
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    postCreateHook = ''
                      MNTPOINT=$(mktemp -d)
                      mount -t btrfs "$device" "$MNTPOINT"
                      trap 'umount "$MNTPOINT"; rm -d "$MNTPOINT"' EXIT

                      if [ ! -e "$MNTPOINT/root-blank" ]; then
                        btrfs subvolume snapshot -r "$MNTPOINT"/root "$MNTPOINT"/root-blank
                      fi

                      if [ ! -e "$MNTPOINT/home-blank" ]; then
                        btrfs subvolume snapshot -r "$MNTPOINT"/home "$MNTPOINT"/home-blank
                      fi
                    '';
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                      };
                      "/home" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                        mountpoint = "/home";
                      };
                      "/persist" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                        mountpoint = "/persist";
                      };
                      "/nix" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                        mountpoint = "/nix";
                      };
                      "/swap" = {
                        mountpoint = "/swap";
                        swap = {
                          swapfile = {
                            size = "16G";
                          };
                        };
                      };
                    };
                    mountpoint = "/partition-root";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
