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
      forceSSL = false;
			enableAuthelia = true;
      addSSL = true;
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

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
