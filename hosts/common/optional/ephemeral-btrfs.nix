# This module implements an ephemeral root in btrfs by restoring the 'root' subvolume of ${config.fileSystems."/".device} to 'root-blank' on boot
{
  lib,
  config,
  ...
}:
let
  root = config.fileSystems."/";

  wipeScript = ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ ${root.device} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      echo "Creating needed directories"
      mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}
      if [ -e "$MNTPOINT/dont-wipe" ]; then
        echo "Skipping wipe"
      else
        echo "Cleaning subvolumes"
        btrfs subvolume delete -R "$MNTPOINT/root"
        btrfs subvolume delete -R "$MNTPOINT/home"

        echo "Restoring blank subvolumes"
        btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
        btrfs subvolume snapshot "$MNTPOINT/home-blank" "$MNTPOINT/home"
      fi
    )
  '';

  # Convert a device path to a systemd .device
  toSystemdDevice =
    device:
    lib.concatStringsSep "-" (
      lib.tail (map (lib.replaceString "-" "\\x2d") (lib.splitString "/" device))
    )
    + ".device";

  phase1Systemd = config.boot.initrd.systemd.enable;
in
{
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
    systemd.services.restore-root = lib.mkIf phase1Systemd {
      description = "Rollback btrfs rootfs";
      wantedBy = [ "initrd.target" ];
      requires = [ (toSystemdDevice root.device) ];
      after = [ (toSystemdDevice root.device) ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };
  };

  fileSystems."/persist".neededForBoot = lib.mkDefault true;
}
