{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server https://headscale.berntsen.nl.eu.org"];
  };
  networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching

  environment.persistence = {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}