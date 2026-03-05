{ ... }:
{
  imports = [
    ./auth
    ./headscale.nix
    ./dns
    ./tuwunel.nix
    ./postgresql.nix
    ./guac-proxy.nix
    ./immich-proxy.nix
    ./miniflux.nix
    ./ha-proxy.nix
    ./overleaf-proxy.nix
  ];
}
