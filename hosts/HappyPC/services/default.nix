{...}: {
  imports = [
    ./headscale.nix
    ./dns
    ./searxng.nix
    ./mysql.nix
    #    ./lidarr.nix
    ./miniflux.nix
  ];
}
