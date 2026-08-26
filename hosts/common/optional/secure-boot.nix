# see: https://github.com/jorritvanderheide/dots/blob/6502af50c72c4affbe25917cceb6e1bde77774ff/modules/features/core/boot.nix#L59
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  sops.secrets.luks_password = {
    sopsFile = ../secrets.yaml;
  };
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.configurationLimit = 2;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";

      # Auto-provision Secure Boot keys (trust-on-first-use).
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };

      # Measured Boot: bind unlock to firmware code (0), kernel/initrd
      # (4) and Secure Boot state (7). make-policy refreshes the TPM NV
      # index on every rebuild, so kernel updates don't break unlock.
      # systemd-pcrlock caps the policy at 8 boot variants.
      # Only in "pcrlock" mode: "static-pcr7" hosts bind to PCR 7
      # directly, and their TPMs fail make-policy's encrypted session
      # (the very reason they run static-pcr7).
      configurationLimit = 2;
      measuredBoot = {
        enable = true;
        pcrs = [
          0
          4
          7
        ];
        pcrlockPolicy = "/var/lib/pcrlock/pcrlock.json";
      };
    };
  };
  systemd.services.tpm-luks-enroll = lib.mkMerge [
    {
      description = "Bind a LUKS TPM2 keyslot for unlock";
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionSecurity = "uefi-secureboot";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "tpm-luks-enroll";
      };
    }

    # Default: bind to the systemd-pcrlock policy (PCRs 0+4+7).
    {
      after = [ "systemd-pcrlock-make-policy.service" ];
      unitConfig.ConditionPathExists = [
        "!/var/lib/tpm-luks-enroll/done"
        "/var/lib/pcrlock/pcrlock.json"
      ];
      script = ''
        PASSWORD="$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.luks_password.path})" \
          ${config.systemd.package}/bin/systemd-cryptenroll \
            --wipe-slot=tpm2 \
            --tpm2-device=auto \
            --tpm2-pcrlock=/var/lib/pcrlock/pcrlock.json \
            /dev/disk/by-partlabel/disk-main-luks
        ${pkgs.coreutils}/bin/touch /var/lib/tpm-luks-enroll/done
      '';
    }
  ];
  environment.persistence = {
    "/persist" = {
      files = [ ];
      directories = [
        "/var/lib/sbctl"
        "/var/lib/tpm2-tss"
        "/var/lib/pcrlock" # pcrlock policy (pcrlockPolicy)
        "/var/lib/pcrlock.d" # pcrlock measurement components (pcrlockDirectory)
        "/var/lib/tpm-luks-enroll" # one-shot enrollment guard
      ];
    };
  };
}
