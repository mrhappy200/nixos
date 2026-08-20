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

  listenBlock = {
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
in
{
  sops.secrets.tuwunel_oidc-client-secret = {
    owner = "conduit";
    group = config.services.authelia.instances.plsFriend.group;
    mode = "770";
    sopsFile = ../secrets.yaml;
  };

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
      registration_token = "aalksdjfhlkajsfhueuir";
      trusted_servers = [ "matrix.org" ];
      sentry = true;
      identity_provider = [
        {
          brand = "Authelia";
          client_id = "IDxdpUoGNi.T6PwRxF~Qa.I_oe-cikIoZl06NPlYHtgApgu8jrVy8~Nz8nYfBzCV8Js0Uefq";
          client_secret_file = config.sops.secrets."tuwunel_oidc-client-secret".path;
          issuer_url = "https://auth.hppy200.dev";
          callback_url = "https://hppy200.dev/_matrix/client/unstable/login/sso/callback/IDxdpUoGNi.T6PwRxF~Qa.I_oe-cikIoZl06NPlYHtgApgu8jrVy8~Nz8nYfBzCV8Js0Uefq";
          trusted = true;
        }
      ];
    };
  };
  environment.persistence = {
    "/persist".directories = [ config.services.matrix-conduit.settings.global.database_path ];
  };

  networking.firewall.allowedTCPPorts = [ 8448 ];
  networking.firewall.allowedUDPPorts = [ 8448 ];

  services.nginx = {
    upstreams = {
      "backend_tuwunel" = {
        servers = {
          "127.0.0.1:8008" = { };
        };
      };
    };

    virtualHosts."${matrix_hostname}" = listenBlock // {
      extraConfig = "client_max_body_size 100M;";
      locations."/" = {
        proxyPass = "http://backend_tuwunel";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
    };

    virtualHosts."62.45.51.87" = listenBlock // {
      extraConfig = "client_max_body_size 100M;";
      locations."/" = {
        proxyPass = "http://backend_tuwunel";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
    };

    virtualHosts."[2001:4c3d:803:9c00:be24:11ff:fef1:6b70]" = listenBlock // {
      extraConfig = "client_max_body_size 100M;";
      locations."/" = {
        proxyPass = "http://backend_tuwunel";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
    };

    virtualHosts."${matrix_hostname}_federation" = {
      serverName = matrix_hostname;
      extraConfig = ''
        client_max_body_size 100M;
        listen 8448 ssl;
        listen [::]:8448 ssl;
        http2 on;
      '';
      locations."/" = {
        proxyPass = "http://backend_tuwunel";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
      useACMEHost = matrix_hostname;
      forceSSL = false;
    };
  };
  #services.nginx = {
  #  virtualHosts."${matrix_hostname}" = listenBlock;
  #  virtualHosts."62.45.51.87" = listenBlock;
  #  virtualHosts."[2001:4c3d:803:9c00:be24:11ff:fef1:6b70]" = listenBlock;

  #  upstreams = {
  #    "backend_conduit" = {
  #      servers = {
  #        "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = { };
  #      };
  #    };
  #  };
  #};
}
