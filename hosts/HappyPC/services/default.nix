{...}: {
  imports = [
    ./headscale.nix
    ./media
    ./dns
    ./searxng.nix
    ./mysql.nix
    #    ./lidarr.nix
    ./miniflux.nix
  ];
}
