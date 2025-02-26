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
    forceSSL = true;
    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://127.0.0.1:8067";
    };
  };
}
