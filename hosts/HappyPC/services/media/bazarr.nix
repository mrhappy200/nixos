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
      forceSSL = true;
      enableAuthelia = true;
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

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
