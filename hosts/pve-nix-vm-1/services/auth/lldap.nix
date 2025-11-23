{
  config,
  lib,
  ...
}: let
in {
  sops.secrets.lldap_pass = {
    owner = "lldap";
    sopsFile = ../../secrets.yaml;
  };
  environment.persistence = {
    "/persist" = {
      directories = [
        {
          directory = "/var/lib/lldap";
          user = "lldap";
        }
      ];
    };
  };

  services.lldap = {
    enable = true;
    environment = {
      LLDAP_JWT_SECRET_FILE = toString config.sops.secrets.authelia_jwtsf.path;
      LLDAP_LDAP_USER_PASS_FILE = toString config.sops.secrets.lldap_pass.path;
    };
    settings = {
      ldap_user_email = "ronanberntsen@gmail.com";
      #force_ldap_user_pass_reset = true;
      http_url = "https://ldap.hppy200.dev";
      database_url = "postgres://lldap?host=/run/postgresql&user=lldap";

      ldap_base_dn = "dc=hppy200,dc=dev";
    };
  };
  systemd.services.lldap.serviceConfig = {
    DynamicUser = lib.mkForce false;
  };
  services.postgresql.ensureDatabases = ["lldap"];
  services.postgresql.ensureUsers = [
    {
      name = "lldap";
      ensureDBOwnership = true;
    }
  ];
  users.users.lldap = {
    description = "LLDAP user";
    createHome = false;
    group = "lldap";
    isSystemUser = true;
  };
  users.groups.lldap = {};
  services.nginx.virtualHosts."lldap.hppy200.dev" = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://127.0.0.1:17170";
    };
  };
}
