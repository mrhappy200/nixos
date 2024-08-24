{
  config,
  pkgs,
  ...
}: {
  sops.secrets.miniflux_admin_pass = {sopsFile = ../secrets.yaml;};

  sops.templates."creds.env".content = ''
    ADMIN_USERNAME = "TheAdmin"
    ADMIN_PASSWORD = "${config.sops.placeholder.miniflux_admin_pass}"
  '';

  environment.systemPackages = [pkgs.miniflux];

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:8756";
    };
    adminCredentialsFile = config.sops.templates."creds.env".path;
  };

  services.nginx.virtualHosts."rss.hppy200.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:8756";
    };
  };

  environment.persistence = {
    "/nix/persist" = {
      directories = ["/var/lib/postgresql"];
    };
  };
}
