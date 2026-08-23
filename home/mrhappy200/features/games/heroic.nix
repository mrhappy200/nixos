{ pkgs, ... }: {
  home.packages = [ pkgs.heroic ];
  home.persistence = {
    "/persist/" = {
      directories = [
        #          "Games"
        ".config/heroic"
      ];
    };
  };
}
