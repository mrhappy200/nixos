{
  disko.devices = {
    nodev = {
      tmpfsRoot = {
        fsType = "tmpfs";
        mountpoint = "/";
        mountOptions = ["size=4G"];
      };
    };
    disk = {
      hdd = {
        type = "disk";
        device = "/dev/disk/by-label/hdd";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              label = "luks-hdd";
              content = {
                type = "luks";
                name = "cryptdrive";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                settings = {
                  crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "hdd" "-f"];
                  subvolumes = {
                    "/persist" = {
                      mountpoint = "/nix/persist-hdd";
                      mountOptions = ["subvol=persist" "compress=zstd:7" "noatime"];
                    };
                  };
                };
              };
            };
          };
        };
      };
      ssd = {
        type = "disk";
        device = "/dev/disk/by-label/nixos";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            swap = {
              label = "swap";
              size = "20G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            luks = {
              size = "100%";
              label = "luks-ssd";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                settings = {
                  crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  subvolumes = {
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "compress=zstd:7" "noatime"];
                    };
                    "/persist" = {
                      mountpoint = "/nix/persist";
                      mountOptions = ["subvol=persist" "compress=zstd:3" "noatime"];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=log" "compress=zstd:3" "noatime"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/nix/persist".neededForBoot = true;
  fileSystems."/nix/persist-hdd".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
