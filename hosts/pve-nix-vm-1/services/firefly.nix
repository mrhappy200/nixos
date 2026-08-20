{ config, pkgs, ... }:
let
  domain = "firefly.hppy200.dev";
  importerDomain = "firefly-importer.hppy200.dev";
  dataDir = "/var/lib/firefly-iii";
  importerDataDir = "/var/lib/firefly-iii-data-importer";
  certDir = "/var/lib/acme/hppy200.dev";
in
{
  sops.secrets.firefly_app_key = {
    owner = "firefly-iii";
    sopsFile = ../secrets.yaml;
  };
  sops.secrets.firefly_data_importer_access_token = {
    owner = "firefly-iii-data-importer";
    sopsFile = ../secrets.yaml;
  };

  # --- Firefly III core ---
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    virtualHost = domain;
    dataDir = dataDir;
    settings = {
      APP_ENV = "production";
      APP_KEY_FILE = config.sops.secrets.firefly_app_key.path;
      SITE_OWNER = "admin@hppy200.dev"; # TODO: your email
      DB_CONNECTION = "pgsql";
      DB_DATABASE = "firefly-iii";
      DB_USERNAME = "firefly-iii"; # matches system user -> peer auth, no password
    };
  };

  services.postgresql.ensureDatabases = [ "firefly-iii" ];
  services.postgresql.ensureUsers = [
    {
      name = "firefly-iii";
      ensureDBOwnership = true;
    }
  ];

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    sslCertificate = "${certDir}/fullchain.pem";
    sslCertificateKey = "${certDir}/key.pem";
  };

  # --- Firefly III Data Importer ---
  services.firefly-iii-data-importer = {
    enable = true;
    enableNginx = true;
    virtualHost = importerDomain;
    dataDir = importerDataDir;
    settings = {
      APP_ENV = "production";
      FIREFLY_III_URL = "https://${domain}";
      FIREFLY_III_ACCESS_TOKEN_FILE = config.sops.secrets.firefly_data_importer_access_token.path;
    };
  };

  services.nginx.virtualHosts.${importerDomain} = {
    forceSSL = true;
    sslCertificate = "${certDir}/fullchain.pem";
    sslCertificateKey = "${certDir}/key.pem";
  };

  environment.persistence."/persist".directories = [
    {
      directory = dataDir;
      user = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
      mode = "0710";
    }
    {
      directory = importerDataDir;
      user = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
      mode = "0710";
    }
  ];
}
