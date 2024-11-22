{ ... }: {
  imports = [
    ./mylar3.nix
    ./jellyfin.nix
    ./lidarr.nix
    ./qbittorrent.nix
    ./radarr.nix
    ./bazarr.nix
    ./prowlarr.nix
    ./sonarr.nix
  ];
  users.groups.mediastack = { };
}
