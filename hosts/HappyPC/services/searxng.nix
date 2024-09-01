{pkgs, ...}: {
  services.searx = {
    package = pkgs.searxng;
    enable = true;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "56719163e01080f878e50c83a114b89afc00dbc6de811fe85d2e2a1274992070";
      };
    };
  };

  services.nginx.virtualHosts."searx.hap.py" = {
    forceSSL = false;
    addSSL = true;
    sslCertificate = "/nix/persist/etc/nginx/certs/searx.hap.py.crt";
    sslCertificateKey = "/nix/persist/etc/nginx/certs/searx.hap.py.key";
    extraConfig = ''
      ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
      ssl_verify_client off;
    '';

    locations."/" = {
	proxyPass = "http://127.0.0.1:8888";
    };
  };
}
