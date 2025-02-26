{lib, ...}: {
  services = {
    prowlarr = {enable = true;};
    # broken
    #flaresolverr = {enable = true;};
    nginx.virtualHosts."prowlarr.hppy200.dev" = {
      forceSSL = true;
      enableAuthelia = true;
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      locations."/" = {proxyPass = "http://127.0.0.1:9696";};
    };
  };

  systemd.services.prowlarr.serviceConfig = {
    DynamicUser = lib.mkForce false;
  };

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [
        {
          directory = "/var/lib/prowlarr";
          user = "prowlarr";
          group = "mediastack";
          mode = "u=rwx,g=rwx,o=rwx";
        }
      ];
    };
  };
}
