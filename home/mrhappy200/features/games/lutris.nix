{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    (pkgs.lutris.override {
      extraPkgs = p: [
        p.wineWowPackages.staging
        p.pixman
        p.libjpeg
        p.gnome.zenity
      ];
    })
  ];

  home.persistence = {
    "/nix/persist/home/mrhappy200" = {
      allowOther = true;
      directories = [
        ".config/lutris"
        ".local/share/lutris"
      ];
    };
  };
}
