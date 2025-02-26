{...}: {
  services = {
    sonarr = {
      enable = true;
      user = "sonarr";
      group = "mediastack";
      dataDir = "/nix/persist-hdd/media/arr/sonarr/data/";
    };
    nginx.virtualHosts."sonarr.hppy200.dev" = {
      forceSSL = false;
      addSSL = true;
      enableAuthelia = true;
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      locations."/" = {proxyPass = "http://127.0.0.1:8989";};
    };
  };
}
