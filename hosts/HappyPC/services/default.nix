{...}: {
  imports = [
    ./headscale.nix
    ./auth
    ./minecraft.nix
    ./logging
    ./postgresql.nix
    ./media
    ./dns
    ./searxng.nix
    ./miniflux.nix
  ];
}
