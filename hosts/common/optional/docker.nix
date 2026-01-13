{virtualisation.docker = {enable = true;};
environment.persistence = {
    "/nix/persist-hdd".directories = ["/var/lib/docker"];
  };
  }
