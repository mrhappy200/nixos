{
  lib,
  config,
  ...
}: {
  services = {
    bazarr = {
      enable = true;
      user = "bazarr";
      group = "mediastack";
    };
    nginx.virtualHosts."bazarr.hppy200.dev" = {
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
        proxyPass = "http://127.0.0.1:6767";
      };
    };
  };

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [
        {
          directory = "/var/lib/bazarr";
          user = "bazarr";
          group = "mediastack";
          mode = "u=rwx,g=rwx,o=rwx";
        }
      ];
    };
  };
}
