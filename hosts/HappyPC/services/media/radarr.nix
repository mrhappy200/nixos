{
  lib,
  config,
  ...
}: {
  services = {
    radarr = {
      enable = true;
      user = "radarr";
      group = "mediastack";
      dataDir = "/nix/persist-hdd/media/arr/radarr/data/";
    };
    nginx.virtualHosts."radarr.hppy200.dev" = {
      forceSSL = false;
      addSSL = true;
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };
  };
}
