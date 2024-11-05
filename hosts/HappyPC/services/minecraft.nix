{ pkgs, lib, ... }:
let

in {
  services.minecraft-server = {
    enable = true;
    eula = true;
  };
  environment.persistence = {
    "/nix/persist".directories = [ "/var/lib/minecraft" ];
  };
}
