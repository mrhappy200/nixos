{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/mysql.nix
    ../../common/optional/postgres.nix

    ./grafana
    ./files-server.nix
    ./git-remote.nix
    ./headscale.nix
    ./prometheus.nix
    ./radicale.nix
  ];
}
