{ ... }: {
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
      sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
      sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
      extraConfig = ''
        ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
        ssl_verify_client off;
      '';

      locations."/" = { proxyPass = "http://127.0.0.1:8989"; };
    };
  };
}
