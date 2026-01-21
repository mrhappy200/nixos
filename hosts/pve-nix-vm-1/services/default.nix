{...}: {
  imports = [
    ./auth
    ./headscale.nix
    ./dns
    ./tuwunel.nix
    ./postgresql.nix
    ./immich-proxy.nix
    ./miniflux.nix
    ./ha-proxy.nix
    ./overleaf-proxy.nix
  ];
}
