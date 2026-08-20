{ config, ... }:
let
  port = "5230";
  dataDir = "/var/lib/memos/";
in
{
  services.memos = {
    enable = true;
    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = "localhost";
      MEMOS_PORT = port;
      MEMOS_DATA = dataDir;
      MEMOS_DRIVER = "postgres";
      MEMOS_DSN = "postgres://memos@/memos?host=/run/postgresql&sslmode=disable";
      MEMOS_INSTANCE_URL = "memos.hppy200.dev";
    };
  };

  services.postgresql.ensureDatabases = [ "memos" ];
  services.postgresql.ensureUsers = [
    {
      name = "memos";
      ensureDBOwnership = true;
    }
  ];

  services.nginx.virtualHosts = {
    "memos.hppy200.dev" = {
      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${port}";
    };
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = dataDir;
        user = config.users.users.memos.name;
        group = config.users.users.memos.group;
        mode = "0755";
      }
    ];
  };
}
