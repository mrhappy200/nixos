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
    settings.server.root_url = "https://grafana.hppy200.dev";
  };

  sops.secrets.grafana_oidc-client-secret = {
    owner = config.services.authelia.instances.plsFriend.user;
    group = config.services.authelia.instances.plsFriend.group;
    mode = "770";
    sopsFile = ../../secrets.yaml;
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
    };
    forceSSL = false;
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
