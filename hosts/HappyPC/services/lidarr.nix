{
  config,
  ...
}: let
  
in {

  services.lidarr = {
    enable = true;
  };
  services.prowlarr.enable = true;

  environment.persistence = {
    "/nix/persist-hdd" = {
      directories = [{ directory = "${toString config.services.lidarr.dataDir}"; user = config.services.lidarr.user; group = config.services.lidarr.group;}];
    };
  };
}
