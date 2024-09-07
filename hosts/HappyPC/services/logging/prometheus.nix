{
  config,
  lib,
  outputs,
  ...
}: let
  hosts = lib.attrNames outputs.nixosConfigurations;
in {
  services.prometheus = {
    enable = true;
    port = 9001;
    globalConfig = {
      # Scrape a bit more frequently
      scrape_interval = "30s";
    };
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "hosts";
        scheme = "http";
        static_configs =
          map (hostname: {
            targets = ["${hostname}:${toString config.services.prometheus.exporters.node.port}"];
            labels.instance = hostname;
          })
          hosts;
      }
      {
        job_name = "headscale";
        scheme = "https";
        static_configs = [{targets = ["headscale.hppy200.dev"];}];
      }
      {
        job_name = "nginx";
        scheme = "https";
        static_configs = [
          {
            targets = [
              "HappyPC.hppy200.dev"
            ];
          }
        ];
      }
      {
        job_name = "jellyfin";
        scheme = "https";
        static_configs = [
          {
            targets = [
              "jellyfin.hppy200.dev"
            ];
          }
        ];
      }
      {
        job_name = "authelia";
        scheme = "http";
        static_configs = [
          {
            targets = [
              "localhost:9959"
            ];
          }
        ];
      }
    ];
  };
  environment.persistence = {
    "/nix/persist".directories = ["/var/lib/prometheus2"];
  };
}
