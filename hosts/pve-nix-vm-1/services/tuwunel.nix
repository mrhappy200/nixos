{
  config,
  lib,
  pkgs,
  flakes,
  ...
}:
# Adapted from:
# https://gitlab.com/famedly/conduit/-/blob/3bfdae795d4d9ec9aeaac7465e7535ac88e47756/nix/README.md
let
  matrix_hostname = "hppy200.dev";

  matrix_hostname_regex = lib.strings.escapeRegex matrix_hostname;

  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}"
    }
  '';

  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://${matrix_hostname}"
      }
    }
  '';

  package = pkgs.matrix-tuwunel;

  binary = "${package}/bin/tuwunel";
in
{
  users.groups.conduit = { };

  users.users.conduit = {
    isSystemUser = true;
    group = "conduit";
    description = "Matrix Conduit user";
  };

  # Ensure the service uses this user (if not already defaulting to it)
  systemd.services.conduit.serviceConfig.User = "conduit";
  systemd.services.conduit.serviceConfig.Group = "conduit";
  systemd.services.conduit.serviceConfig.ExecStart = lib.mkForce binary;
  systemd.services.conduit.serviceConfig.DynamicUser = lib.mkForce false;

  services.matrix-conduit = {
    enable = true;
    package = package;
    settings.global = {
      server_name = matrix_hostname;
      allow_registration = false;
      database_backend = "rocksdb";
      trusted_servers = [ "matrix.org" ];
      sentry = true;
    };
  };
  environment.persistence = {
    "/persist".directories = [ config.services.matrix-conduit.settings.global.database_path ];
  };
  services.nginx = {
    virtualHosts."${matrix_hostname}" = {
      forceSSL = true;

      sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8448;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 8448;
          ssl = true;
        }
      ];

      locations."/_matrix/" = {
        proxyPass = "http://backend_conduit$request_uri";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_buffering off;
        '';
      };
      locations."=/.well-known/matrix/server" = {
        alias = "${well_known_server}";

        extraConfig = ''
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${well_known_client}";

        extraConfig = ''
          default_type application/json;
          add_header Access-Control-Allow-Origin "*";
        '';
      };

      extraConfig = ''
        merge_slashes off;
      '';
    };

    upstreams = {
      "backend_conduit" = {
        servers = {
          "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = { };
        };
      };
    };
  };
}
