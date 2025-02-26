{config, ...}: let
in {
  services = {
    lidarr = {
      enable = true;
      user = "lidarr";
      group = "mediastack";
      dataDir = "/nix/persist-hdd/media/arr/lidarr/data/";
    };
    nginx.virtualHosts."lidarr.hppy200.dev" = {
      forceSSL = true;
      enableAuthelia = true;
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
      };
    };
  };

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [
        {
          directory = "${toString config.services.lidarr.dataDir}";
          user = config.services.lidarr.user;
          group = config.services.lidarr.group;
        }
      ];
    };
  };
}
