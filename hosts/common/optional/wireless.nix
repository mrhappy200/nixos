{
  config,
  lib,
  pkgs,
  ...
}: {
  # Wireless secrets stored through sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative
    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "Marola_WiFi" = {
        pskRaw = "ext:MAROLA";
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = {};

  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
