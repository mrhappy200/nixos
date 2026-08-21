{ pkgs, ... }: {
  home.packages = [ pkgs.heroic ];
  persistence = {
    "/persist/" = {
      directories = [
        #          "Games"
        ".config/heroic"
      ];
    };
  };
}
