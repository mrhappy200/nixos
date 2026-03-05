{
  config,
  pkgs,
  lib,
  ...
}:
let
  stateDir = "/var/lib/technitium-dns-server";
  package = pkgs.technitium-dns-server;
  binary = "${package}/bin/technitium-dns-server";
in
{
  users.groups.technitium = { };

  users.users.technitium = {
    isSystemUser = true;
    group = "technitium";
    description = "Technitium DNS server user";
  };

  # Ensure the service uses this user (if not already defaulting to it)
  environment.persistence = {
    "/persist".directories = [ stateDir ];
  };

  systemd.services.technitium-dns-server.environment = {
    # Forces .NET to poll for file changes instead of using recursive inotify watchers
    DOTNET_USE_POLLING_FILE_WATCHER = "1";
  };
  systemd.services.technitium-dns-server = {
    serviceConfig = {
      User = "technitium";
      Group = "technitium";
      ExecStart = "${binary} ${stateDir}";
      # Explicitly set the working directory to the state folder
      WorkingDirectory = stateDir;
      # Required for .NET apps on NixOS to find their libraries if not wrapped
      Restart = "on-failure";
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    };
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [
      53
      5380
      53443
    ];
  };

  services.nginx.virtualHosts."technitium.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://localhost:5380";
    };
  };

  #services.technitium-dns-server = {
  #  enable = true;
  #  openFirewall = true;
  #};
  #services.coredns.enable = true;
  #services.coredns.config = ''
  #         . {
  #           # Cloudflare and Google
  #           forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
  #           cache
  #         }
  #'';
}
