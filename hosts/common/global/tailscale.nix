{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server https://headscale.hppy200.dev"];
  };
  networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching

  environment.persistence = {
    "/nix/persist".directories = ["/var/lib/tailscale"];
  };
}
