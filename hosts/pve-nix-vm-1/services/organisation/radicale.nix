{
  config,
  ...
}:
let
  port = "5232";
in
{
  services = {
    radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [
            "127.0.0.1:${port}"
            "::1:${port}"
          ];
        };
        auth = {
          type = "htpasswd";
          # htpasswd -5 -c /dev/stdout ronan@hppy200.dev
          htpasswd_filename = config.sops.secrets.radicale-htpasswd.path;
          htpasswd_encryption = "autodetect";
        };
        storage = {
          filesystem_folder = "/var/lib/radicale/collections";
        };
      };
    };
    nginx.virtualHosts = {
      "dav.hppy200.dev" = {
        sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
        sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${port}";
        extraConfig = ''
          proxy_set_header  X-Script-Name /;
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass_header Authorization;
        '';
      };
    };
  };
  sops.secrets.radicale-htpasswd = {
    sopsFile = ../../secrets.yaml;
    owner = config.users.users.radicale.name;
    group = config.users.users.radicale.group;
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/radicale";
        user = config.users.users.radicale.name;
        group = config.users.users.radicale.group;
        mode = "0755";
      }
    ];
  };
}
