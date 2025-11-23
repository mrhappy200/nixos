{
  config,
  pkgs,
  ...
}: {
  sops.secrets.miniflux_admin_pass = {sopsFile = ../secrets.yaml;};

  sops.secrets.miniflux_oidc-client-secret = {
    owner = "miniflux";
    group = config.services.authelia.instances.plsFriend.group;
    mode = "770";
    sopsFile = ../secrets.yaml;
  };

  users.users.miniflux = {
    description = "Miniflux user";
    createHome = false;
    group = "miniflux";
    isSystemUser = true;
  };
  users.groups.miniflux = {};

  sops.templates."creds.env".content = ''
    ADMIN_USERNAME = "TheAdmin"
    ADMIN_PASSWORD = "${config.sops.placeholder.miniflux_admin_pass}"
  '';

  environment.systemPackages = [pkgs.miniflux];

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:8756";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_CLIENT_ID = "dKe-NfZimN7kn911_BsFC65MJepKft8WKDGieGwAlQn4a3h7dPwQYMgocB1LeKvLj1VFoFgx5tFfnL35RIXZ.d-iHXvRb~rIZgU";
      OAUTH2_CLIENT_SECRET_FILE = config.sops.secrets."miniflux_oidc-client-secret".path;
      OAUTH2_REDIRECT_URL = "https://rss.hppy200.dev/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.hppy200.dev";
      OAUTH2_USER_CREATION = "1";
      DISABLE_LOCAL_AUTH = "1";
    };
    adminCredentialsFile = config.sops.templates."creds.env".path;
  };

  services.nginx.virtualHosts."rss.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://localhost:8756";
    };
  };
}
