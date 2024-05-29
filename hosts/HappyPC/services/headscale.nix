{config, ...}: let
  domain = "headscale.berntsen.nl.eu.org";
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      dns = {baseDomain = "example.com";};
      settings = {
        logtail.enabled = false;

        server_url = "https://${domain}";
      };
    };

    nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.headscale.port}";
        proxyWebsockets = true;
      };
    };
  };

  environment.systemPackages = [config.services.headscale.package];

  environment.persistence = {
    "/nix/persist".directories = ["/var/lib/headscale"];
  };
}
