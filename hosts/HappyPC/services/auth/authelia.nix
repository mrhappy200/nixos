{
  lib,
  config,
  ...
}: let
in {
  sops.secrets = {
    authelia_sekf = {
      owner = config.services.authelia.instances.plsFriend.user;
      sopsFile = ../../secrets.yaml;
    };
    authelia_jwtsf = {
      owner = config.services.authelia.instances.plsFriend.user;
      mode = "770";
      group = "lldap";
      sopsFile = ../../secrets.yaml;
    };
    authelia_hmac = {
      owner = config.services.authelia.instances.plsFriend.user;
      sopsFile = ../../secrets.yaml;
    };
    authelia_jwk = {
      owner = config.services.authelia.instances.plsFriend.user;
      sopsFile = ../../secrets.yaml;
    };
    authelia_smtp_pass = {
      owner = config.services.authelia.instances.plsFriend.user;
      sopsFile = ../../secrets.yaml;
    };
    authelia_ldap_pass = {
      owner = config.services.authelia.instances.plsFriend.user;
      sopsFile = ../../secrets.yaml;
    };
  };

  services.postgresql.ensureDatabases = [config.services.authelia.instances."plsFriend".user];
  services.postgresql.ensureUsers = [
    {
      name = config.services.authelia.instances."plsFriend".user;
      ensureDBOwnership = true;
    }
  ];

  services.authelia.instances."plsFriend" = {
    enable = true;
    environmentVariables = {
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets.authelia_smtp_pass.path;
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.sops.secrets.authelia_ldap_pass.path;
    };
    settings = {
      telemetry.metrics.enabled = false;
      default_2fa_method = "totp";
      notifier.smtp = {
        username = "ronanberntsen@gmail.com";
        sender = "admin@hppy200.dev";
        host = "smtp.gmail.com";
        port = "587";
      };
      storage.postgres = {
        address = "unix:///run/postgresql";
        database = config.services.authelia.instances."plsFriend".user;
        username = config.services.authelia.instances."plsFriend".user;
        password = "authelia";
      };

      totp = {
        issuer = "hppy200.dev";
        algorithm = "sha512";
      };

      authentication_backend = {
        password_reset = {disable = false;};
        refresh_interval = "1m";
        ldap = {
          implementation = "custom";
          address = "ldap://localhost:3890";
          timeout = "5s";
          start_tls = false;
          base_dn = "dc=hppy200,dc=dev";
          additional_users_dn = "ou=people";
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          additional_groups_dn = "ou=groups";
          groups_filter = "(member={dn})";
          attributes = {
            display_name = "displayName";
            username = "uid";
            group_name = "cn";
            mail = "mail";
          };
          user = "uid=bind_user,ou=people,dc=hppy200,dc=dev";
        };
      };

      access_control = {
        default_policy = "deny";
        rules = lib.mkAfter [
          {
            domain_regex = "^(radarr|lidarr|sonarr|prowlarr|qbt|request|jellyfin)\.hppy200\.dev";
            subject = "group:arr_admin";
            policy = "two_factor";
          }
          {
            domain_regex = "^(jellyfin)\.hppy200\.dev";
            subject = "group:arr_user";
            policy = "one_factor";
          }
          {
            domain_regex = "^(request)\.hppy200\.dev";
            subject = "group:arr_user";
            policy = "two_factor";
          }
        ];
      };
      session.cookies = [
        {
          domain = "hppy200.dev";
          authelia_url = "https://auth.hppy200.dev";
          default_redirection_url = "https://hppy200.dev";
          inactivity = "3m";
          expiration = "10m";
          remember_me = "1M";
        }
      ];
      server.endpoints.authz.auth-request.implementation = "AuthRequest";
      identity_providers.oidc = {
        authorization_policies = {
          miniflux = {
            default_policy = "deny";
            rules = [
              {
                "subject" = "group:rss";
                "policy" = "two_factor";
              }
            ];
          };
          vpn = {
            default_policy = "deny";
            rules = [
              {
                "subject" = "group:vpn";
                "policy" = "two_factor";
              }
            ];
          };
        };
      };
    };

    settingsFiles = [./oidc_clients.yaml];

    secrets = {
      storageEncryptionKeyFile = config.sops.secrets.authelia_sekf.path;
      jwtSecretFile = config.sops.secrets.authelia_jwtsf.path;
      oidcIssuerPrivateKeyFile = config.sops.secrets."authelia_jwk".path;
      oidcHmacSecretFile = config.sops.secrets."authelia_hmac".path;
    };
  };
  services.nginx.virtualHosts."auth.hppy200.dev" = {
    forceSSL = true;
    sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
    sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
    extraConfig = ''
      ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
      ssl_verify_client off;
    '';

    locations = {
      "/" = {
        proxyPass = "http://localhost:9091";
        extraConfig = ''
          				## Headers
          proxy_set_header Host $host;
          proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-URI $request_uri;
          proxy_set_header X-Forwarded-Ssl on;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Real-IP $remote_addr;

          ## Basic Proxy Configuration
          client_body_buffer_size 128k;
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; ## Timeout if the real server is dead.
          proxy_redirect  http://  $scheme://;
          proxy_http_version 1.1;
          proxy_cache_bypass $cookie_session;
          proxy_no_cache $cookie_session;
          proxy_buffers 64 256k;

          ## Trusted Proxies Configuration
          ## Please read the following documentation before configuring this:
          ##     https://www.authelia.com/integration/proxies/nginx/#trusted-proxies
          # set_real_ip_from 10.0.0.0/8;
          # set_real_ip_from 172.16.0.0/12;
          # set_real_ip_from 192.168.0.0/16;
          # set_real_ip_from fc00::/7;
          real_ip_header X-Forwarded-For;
          real_ip_recursive on;

          ## Advanced Proxy Configuration
          send_timeout 5m;
          proxy_read_timeout 360;
          proxy_send_timeout 360;
          proxy_connect_timeout 360;
        '';
      };
      "/api/verify" = {
        proxyPass = "http://localhost:9091";
      };
      "/api/authz" = {
        proxyPass = "http://localhost:9091";
      };
    };
  };
}
