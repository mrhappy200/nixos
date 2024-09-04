{
  config,
  pkgs,
  ...
}: {
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "grafana.hppy200.dev";
    port = 2342;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
    };
    forceSSL = false;
    enableAuthelia = true;
    addSSL = true;
    sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
    sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
    extraConfig = ''
      ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
      ssl_verify_client off;
    '';
  };
  environment.persistence = {
    "/nix/persist".directories = ["/var/lib/grafana"];
  };
}
