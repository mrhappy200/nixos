{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = [pkgs.factorio];
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
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
