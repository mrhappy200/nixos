{
  imports = [
    ./khal.nix
    ./khard.nix
    ./oama.nix
    ./syncthing.nix
    # Calendar and todoman require mail
    ./mail.nix
    ./calendar.nix
    ./todoman.nix
    ./neomutt.nix

    # Pass feature is required
    ../pass
  ];
}
