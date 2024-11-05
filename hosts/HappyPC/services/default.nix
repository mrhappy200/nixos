{ ... }: {
  imports = [
    ./headscale.nix
    #    ./home-assistant.nix
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
