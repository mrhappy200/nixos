{pkgs, ...}: {
  sops.secrets.searx-secret_key = {
    owner = "searx";
    sopsFile = ../secrets.yaml;
  };
  services.searx = {
    package = pkgs.searxng;
    enable = true;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "";
      };
    };
  };
  services.nginx.virtualHosts."searx.hppy200.dev" = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8888";
    };
  };
}
