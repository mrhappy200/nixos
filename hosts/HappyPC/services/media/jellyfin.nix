{ lib, ... }: {
  services = {
    jellyfin = {
      enable = true;
      user = "jellyfin";
      group = "mediastack";
      logDir = "/nix/persist-hdd/media/jellyfin/log/";
      cacheDir = "/nix/persist/jellycache/";
      dataDir = "/nix/persist-hdd/media/jellyfin/data/";
      configDir = "/nix/persist-hdd/media/jellyfin/config/";
    };

    jellyseerr.enable = true;

    nginx.virtualHosts."jellyfin.hppy200.dev" = {
      forceSSL = false;
      addSSL = true;
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

      locations."/" = { proxyPass = "http://127.0.0.1:8096"; };
    };
    nginx.virtualHosts."request.hppy200.dev" = {
      forceSSL = false;
      addSSL = true;
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

      locations."/" = { proxyPass = "http://127.0.0.1:5055"; };
    };
  };

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [{
        directory = "/var/lib/jellyseerr";
        user = "jellyfin";
        group = "mediastack";
        mode = "u=rwx,g=rwx,o=rwx";
      }];
    };
  };

  systemd.services.jellyseerr.serviceConfig = {
    DynamicUser = lib.mkForce false;
  };

  networking.firewall.allowedUDPPorts = [ 1900 ];
}
