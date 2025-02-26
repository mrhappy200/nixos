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
      forceSSL = true;
      enableAuthelia = true;
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };
  };
}
