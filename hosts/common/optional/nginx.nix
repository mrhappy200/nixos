{
  lib,
  config,
  ...
}: let
  inherit (config.networking) hostName;
in {
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";

      virtualHosts."${hostName}.hppy200.dev" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        locations."/metrics" = {
          proxyPass = "http://localhost:${
            toString config.services.prometheus.exporters.nginxlog.port
          }";
        };
      };
    };

    prometheus.exporters.nginxlog = {
      enable = true;
      group = "nginx";
      settings.namespaces = [
        {
          name = "filelogger";
          source.files = ["/var/log/nginx/access.log"];
          format = ''
            $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'';
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
