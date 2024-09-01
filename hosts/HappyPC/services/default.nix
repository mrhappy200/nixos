{...}: {
  imports = [
    ./headscale.nix
		./auth
    ./logging
    ./media
    ./dns
    ./searxng.nix
    ./mysql.nix
    ./miniflux.nix
  ];
}
