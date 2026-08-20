{ config, lib, ... }:
{
  sops.secrets = {
    "sonarr/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "sonarr/password" = {
      sopsFile = ../../secrets.yaml;
    };
    "radarr/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "radarr/password" = {
      sopsFile = ../../secrets.yaml;
    };
    "lidarr/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "lidarr/password" = {
      sopsFile = ../../secrets.yaml;
    };
    "prowlarr/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "prowlarr/password" = {
      sopsFile = ../../secrets.yaml;
    };
    "jellyfin/mrhappy200_password" = {
      sopsFile = ../../secrets.yaml;
    };
    "jellyfin/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "seerr/api_key" = {
      sopsFile = ../../secrets.yaml;
    };
    "qbittorrent/api_password" = {
      sopsFile = ../../secrets.yaml;
    };
    #"wireguard/conf" = { };
    ##"sabnzbd/api_key" = { };
    ##"sabnzbd/nzb_key" = { };
    ##"sabnzbd/username" = { };
    ##"sabnzbd/password" = { };
    ##"usenet/eweka/username" = { };
    ##"usenet/eweka/password" = { };
    ##"usenet/newsgroupdirect/username" = { };
    ##"usenet/newsgroupdirect/password" = { };
  };

  environment.persistence = {
    "/persist/".directories = [ "/var/cache/jellyfin" ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (
    map
      (sub: {
        name = "${sub}.hppy200.dev";
        value = {
          sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";
        };
      })
      [
        "sonarr"
        "radarr"
        "lidarr"
        "prowlarr"
        "jellyfin"
        "qbittorrent"
        "seerr"
      ]
  );

  virtualisation.oci-containers = {
    backend = "podman";
    containers.byparr = {
      image = "ghcr.io/thephaseless/byparr:latest";
      ports = [ "127.0.0.1:8191:8191" ]; # loopback only — not exposed externally
      autoStart = true;
    };
  };

  nixflix = {
    enable = true;
    mediaDir = "/persist/arrstack/media";
    stateDir = "/persist/arrstack/.state";
    downloadsDir = "/persist/arrstack/downloads";
    mediaUsers = [ "mrhappy200" ];

    theme = {
      enable = true;
      name = "overseerr";
    };

    # Reverse proxy (choose nginx or caddy, not both)
    nginx = {
      enable = true;
      forceSSL = true;
      domain = "hppy200.dev";
      addHostsEntries = false; # Disable this if you have your own DNS configuration
    };

    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."sonarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."sonarr/password".path;
      };
    };

    flaresolverr = {
      enable = false;
    };

    radarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."radarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."radarr/password".path;
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = {
        enable = true;
      };
    };

    lidarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."lidarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."lidarr/password".path;
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."prowlarr/password".path;
        indexers = [
        ];
        indexerProxies = [
          {
            name = "FlareSolverr"; # schema name — Byparr is API-compatible
            tags = [ "flaresolverr" ];
            host = "http://127.0.0.1:8191";
            requestTimeout = 60;
          }
        ];
      };
    };

    # I don't have a subscription to any usenet providers
    ##sabnzbd = {
    ##  enable = false;

    ##  settings = {
    ##    misc = {
    ##      api_key._secret = config.sops.secrets."sabnzbd/api_key".path;
    ##      nzb_key._secret = config.sops.secrets."sabnzbd/nzb_key".path;
    ##      username._secret = config.sops.secrets."sabnzbd/username".path;
    ##      password._secret = config.sops.secrets."sabnzbd/password".path;
    ##    };

    ##    servers = [
    ##      {
    ##        name = "Eweka";
    ##        host = "sslreader.eweka.nl";
    ##        port = 563;
    ##        username._secret = config.sops.secrets."usenet/eweka/username".path;
    ##        password._secret = config.sops.secrets."usenet/eweka/password".path;
    ##        connections = 20;
    ##        ssl = true;
    ##        priority = 0;
    ##        retention = 3000;
    ##      }
    ##      {
    ##        name = "NewsgroupDirect";
    ##        host = "news.newsgroupdirect.com";
    ##        port = 563;
    ##        username._secret = config.sops.secrets."usenet/newsgroupdirect/username".path;
    ##        password._secret = config.sops.secrets."usenet/newsgroupdirect/password".path;
    ##        connections = 10;
    ##        ssl = true;
    ##        priority = 1;
    ##        optional = true;
    ##        backup = true;
    ##      }
    ##    ];
    ##  };
    ##};

    torrentClients.qbittorrent = {
      enable = true;
      password._secret = config.sops.secrets."qbittorrent/api_password".path;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          WebUI = {
            Username = "mrhappy200";
            Password_PBKDF2 = "9RmPtYp2MM/iYjXg63Q5Bw==:BfWsI82+ytDT4TnHg0UpYjz+W4vyBRLkh495FchgIzH/fSjwePLRHazto3kzXkCV7yChWAGuW36WGHiuiuyvhQ==";
          };
          General.Locale = "en";
        };

      };
      categories = {
        radarr = lib.optionalString (config.nixflix.radarr.enable or false
        ) "/persist/arrstack/downloads/torrent/radarr";

        sonarr = lib.optionalString (config.nixflix.radarr.enable or false
        ) "/persist/arrstack/downloads/torrent/sonarr";

        lidarr = lib.optionalString (config.nixflix.radarr.enable or false
        ) "/persist/arrstack/downloads/torrent/lidarr";

        prowlarr = lib.optionalString (config.nixflix.radarr.enable or false
        ) "/persist/arrstack/downloads/torrent/prowlarr";
      };
    };

    jellyfin = {
      enable = true;
      apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
      users = {
        admin = {
          mutable = false;
          policy.isAdministrator = true;
          password._secret = config.sops.secrets."jellyfin/mrhappy200_password".path;
        };
      };
    };

    seerr = {
      enable = false;
      apiKey._secret = config.sops.secrets."seerr/api_key".path;
    };
  };
}
