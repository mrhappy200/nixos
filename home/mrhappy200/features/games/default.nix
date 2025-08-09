{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./steam.nix
    ./prism-launcher.nix
    ./mangohud.nix
    #    ./satisfactory.nix
  ];
  home = {
    #packages = with pkgs; [heroic gamescope protontricks];
    packages = with pkgs; [
      gamescope
      protontricks
    ];
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        allowOther = true;
        directories = [
          #          "Games"
          ".config/heroic"
        ];
      };
    };
  };
}
