{
  config,
  pkgs,
  lib,
  ...
}:
let
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
  systemd.services.technitium-dns-server.serviceConfig.User = "technitium";
  systemd.services.technitium-dns-server.serviceConfig.Group = "technitium";
  systemd.services.technitium-dns-server.serviceConfig.ExecStart = lib.mkForce binary;
  systemd.services.technitium-dns-server.serviceConfig.DynamicUser = lib.mkForce false;

  #environment.persistence = {
  #  "/persist".directories = [ "/var/lib/technitium-dns-server" ];
  #};

  services.technitium-dns-server = {
    enable = true;
    openFirewall = true;
  };
  #services.coredns.enable = true;
  #services.coredns.config = ''
  #         . {
  #           # Cloudflare and Google
  #           forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
  #           cache
  #         }
  #'';
}
