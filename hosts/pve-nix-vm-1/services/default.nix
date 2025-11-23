{...}: {
  imports = [
    ./auth
    ./headscale.nix
    ./postgresql.nix
    ./immich-proxy.nix
    ./miniflux.nix
  ];
}
