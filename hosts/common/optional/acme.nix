{config, ...}: {
  sops.secrets.cloudflare_api_token = {
    sopsFile = ../secrets.yaml;
  };

  sops.templates."cloudflare.env".content = ''
    CF_API_EMAIL="ronan@hppy200.dev"
    CF_DNS_API_TOKEN="${config.sops.placeholder.cloudflare_api_token}"'';
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults = {
      email = "ronan@hppy200.dev";
      #server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
    acceptTerms = true;

    certs = {
      "hppy200.dev" = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.templates."cloudflare.env".path;
        extraDomainNames = ["*.hppy200.dev"];
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];

  environment.persistence = {
    "/nix/persist" = {
      directories = ["/var/lib/acme"];
    };
  };
}
