{
  lib,
  config,
  ...
}: {
  services = {
    prowlarr = {
      enable = true;
    };
    nginx.virtualHosts."prowlarr.hppy200.dev" = {
      forceSSL = false;
      addSSL = true;
      enableAuthelia = true;
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
    };
  };

  systemd.services.prowlarr.serviceConfig = {
    DynamicUser = lib.mkForce false;
  };

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [
        {
          directory = "/var/lib/private/prowlarr";
          user = "prowlarr";
          group = "mediastack";
          mode = "u=rwx,g=rwx,o=rwx";
        }
      ];
    };
  };
}
