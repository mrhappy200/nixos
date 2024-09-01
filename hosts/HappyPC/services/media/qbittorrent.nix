{
  pkgs,
  lib,
  config,
  ...
}: let
  configDir = "/nix/persist-hdd/media/qbittorrent/config";
  dataDir = "/nix/persist-hdd/media/qbittorrent/data";
  port = 8067;
  user = "qbittorrent";
  group = "mediastack";
in {
  systemd.services.qbittorrent = {
    after = ["network.target"];
    description = "qBittorrent Daemon";
    wantedBy = ["multi-user.target"];
    path = [pkgs.qbittorrent-nox];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox \
          --profile=${configDir} \
          --webui-port=${toString port}
      '';
      # To prevent "Quit & shutdown daemon" from working; we want systemd to
      # manage it!
      Restart = "on-success";
      User = user;
      Group = group;
      UMask = "0002";
      LimitNOFILE = 4096;
    };
  };

  users.users = lib.mkIf (user == "qbittorrent") {
    qbittorrent = {
      inherit group;
      home = dataDir;
      createHome = true;
      description = "qBittorrent Daemon user";
      isSystemUser = true;
    };
  };
  services.nginx.virtualHosts."qbt.hppy200.dev" = {
    forceSSL = false;
    addSSL = true;
    sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
    sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
    extraConfig = ''
      ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
      ssl_verify_client off;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:8067";
    };
  };
}
