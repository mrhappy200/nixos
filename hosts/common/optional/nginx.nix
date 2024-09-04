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
      logError = "stderr info";
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";

      virtualHosts."${hostName}.hppy200.dev" = {
        default = true;
        forceSSL = true;
        locations."/metrics" = {
          proxyPass = "http://localhost:${toString config.services.prometheus.exporters.nginxlog.port}";
        };
        sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
        sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
        extraConfig = ''
          ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
          ssl_verify_client off;
        '';
      };
    };

    prometheus.exporters.nginxlog = {
      enable = true;
      group = "nginx";
      settings.namespaces = [
        {
          name = "filelogger";
          source.files = ["/var/log/nginx/access.log"];
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
