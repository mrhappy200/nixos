{
  config,
  pkgs,
  ...
}: let
in {
  services.mysql = {
    package = pkgs.mariadb;
    enable = true;
  };

  environment.persistence = {
    "/nix/persist" = {
      directories = ["/var/lib/mysql"];
    };
  };
}
