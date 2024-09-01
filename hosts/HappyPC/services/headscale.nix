{config, ...}: let
  derpPort = 3478;
in {
  services = {
    headscale = {
      enable = true;
      port = 8085;
      address = "127.0.0.1";
      settings = {
        dns_config = {
          override_local_dns = true;
          base_domain = "hppy200.dev";
          magic_dns = true;
          domains = ["ts.hppy200.dev"];
          nameservers = ["100.22.0.1" "1.1.1.1"];
        };
        server_url = "https://headscale.hppy200.dev";
        metrics_listen_addr = "127.0.0.1:8095";
        log = {
          level = "warn";
        };
        ip_prefixes = [
          "100.22.0.0/24"
          "fd7a:115c:a1e0:22::/64"
        ];
        derp.server = {
          enable = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:${toString derpPort}";
        };
      };
    };

    nginx.virtualHosts = {
      "headscale.hppy200.dev" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
          "/metrics" = {
            proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
          };
        };
      };
      "headscale.berntsen.nl.eu.org" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "302 https://headscale.hppy200.dev$request_uri";
      };
    };
  };

  # Derp server
  networking.firewall.allowedUDPPorts = [derpPort];

  environment.systemPackages = [config.services.headscale.package];

  environment.persistence = {
    "/nix/persist".directories = ["/var/lib/headscale"];
  };
}
