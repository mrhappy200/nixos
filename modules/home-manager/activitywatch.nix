{ config, lib, pkgs, ... }:
{
home.packages = [
  pkgs.aw-server-rust
  pkgs.aw-watcher-window
  pkgs.aw-watcher-afk
  pkgs.activitywatch
];

home.persistence."/nix/persist/home/mrhappy200/" = {
  directories = [
    ".local/share/activitywatch"
    ".config/activitywatch"
    ".cache/activitywatch"
  ];
};

}
