{ config, ... }:
{
  hardware.bluetooth = {
    enable = true;
  };

  # Same secrets file as before — it's already in `key=value` line format
  # (marola=..., eduroam=...), which happens to also be valid EnvironmentFile
  # syntax, so we can reuse it as-is for ensureProfiles' variable substitution.
  # NetworkManager-ensure-profiles.service runs as root, so no need for a
  # custom owner/group anymore (defaults to root:root, mode 0400).
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
  };

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;

    # Declarative connection profiles (NM keyfile format), with secrets
    # pulled in from the sops-decrypted environment file at activation time.
    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets.wireless.path
      ];

      profiles = {
        "Marola_WiFi" = {
          connection = {
            id = "Marola_WiFi";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "Marola_WiFi";
          };
          wifi-security = {
            key-mgmt = "sae";
            psk = "$marola";
          };
          ipv4.method = "auto";
          ipv6 = {
            method = "auto";
            addr-gen-mode = "default";
          };
        };

        "eduroam" = {
          connection = {
            id = "eduroam";
            type = "wifi";
            autoconnect-priority = 2;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "eduroam";
            hidden = true;
          };
          wifi-security = {
            key-mgmt = "wpa-eap";
          };
          "802-1x" = {
            eap = "ttls";
            identity = "16942701@uva.nl"; # not your email but your id + @uva.nl
            anonymous-identity = "anonymous@uva.nl";
            phase2-auth = "pap";
            password = "$eduroam";
          };
          ipv4.method = "auto";
          ipv6 = {
            method = "auto";
            addr-gen-mode = "default";
          };
        };
      };
    };
  };
}
