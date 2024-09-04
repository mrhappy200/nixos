{...}: {
  imports = [
    ./headscale.nix
    ./auth
    ./logging
    ./postgresql.nix
    ./media
    ./dns
    ./searxng.nix
    ./miniflux.nix
  ];
}
