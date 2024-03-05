{ config, lib, pkgs, ... }:
{
services = {
  syncthing = {
    enable = true;
    user = "mrhappy200";
    dataDir = "/nix/persist-hdd/syncthing/data";
    configDir = "/nix/persist-hdd/syncthing/config";
    guiAddress = "0.0.0.0:8384";
    # overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    # overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    # settings = {
    #   devices = {
    #     "device1" = { id = "DEVICE-ID-GOES-HERE"; };
    #     "device2" = { id = "DEVICE-ID-GOES-HERE"; };
    #   };
    #   folders = {
    #     "Documents" = {         # Name of folder in Syncthing, also the folder ID
    #       path = "/home/myusername/Documents";    # Which folder to add to Syncthing
    #       devices = [ "device1" "device2" ];      # Which devices to share the folder with
    #     };
    #     "Example" = {
    #       path = "/home/myusername/Example";
    #       devices = [ "device1" ];
    #       ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
    #     };
    #   };
    # };
  };
};
networking.firewall.allowedTCPPorts = [ 8384 22000 ];
networking.firewall.allowedUDPPorts = [ 22000 21027 ];
services.syncthing.extraOptions.gui = {
    user = "mrhappy200";
    password = "ronan123";
};
}
