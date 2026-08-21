{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./steam.nix
    ./mangohud.nix
  ];
  home = {
    #packages = with pkgs; [heroic gamescope protontricks];
    packages = with pkgs; [
      gamescope
      protontricks
    ];

  };
}
