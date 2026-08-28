{ config, ... }:
{
  hardware.bluetooth = {
    enable = true;
  };

  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    owner = config.users.users.wpa_supplicant.name;
    group = config.users.users.wpa_supplicant.group;
  };

  networking.wireless = {
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    enable = true;
    fallbackToWPA2 = false;
    # The sandbox binds secretsFile into the unit's namespace, so a secret that
    # can't be decrypted kills the daemon (and the control socket needed to
    # connect by hand and fix it). Also breaks wpa_gui.
    enableHardening = false;
    # The P2P device's control socket never gets ctrl_interface_group applied
    # (upstream doesn't copy the field when creating that interface), so with
    # the daemon running as root it ends up root-only. wpa_gui scans the socket
    # directory, hits p2p-dev-* first and gives up before reaching the real
    # interface. We don't use Wi-Fi Direct anyway.
    extraConfig = "p2p_disabled=1";
    # Declarative
    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "Marola_WiFi" = {
        pskRaw = "ext:marola";
      };
      "eduroam" = {
        hidden = true;
        priority = 2;
        auth = ''
          key_mgmt=WPA-EAP
          eap=TTLS
          identity="16942701@uva.nl" #not your email but your id + @uva.nl
          password=ext:eduroam
          anonymous_identity="anonymous@uva.nl"
          phase2="auth=PAP"
        '';
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = true;
  };
}
