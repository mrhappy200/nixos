{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = [pkgs.factorio];
    persistence = {
      "/persist/" = {
        directories = [
          {
            directory = ".factorio";
            method = "bindfs";
          }
        ];
      };
    };
  };
}
