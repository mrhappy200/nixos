{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.prismlauncher];

  home.persistence = {
    "/nix/persist/home/mrhappy200".directories = [".local/share/PrismLauncher"];
  };
}
