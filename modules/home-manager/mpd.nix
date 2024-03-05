{ config, lib, pkgs, ... }:
{
home.packages = [
pkgs.mpc-cli
];

services.mpd = {
  enable = true;
  musicDirectory = "/home/mrhappy200/Music";
  network.startWhenNeeded = true;
};
programs.ncmpcpp.enable = true;
programs.ncmpcpp.mpdMusicDir = "/home/mrhappy200/Music";

home.persistence."/nix/persist/home/mrhappy200/" = {
  directories = [
    "Music"
  ];
};

}
