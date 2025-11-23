{...}: {
  imports = [
    ./authelia.nix
    ./nginx_options.nix
    ./lldap.nix
  ];
}
