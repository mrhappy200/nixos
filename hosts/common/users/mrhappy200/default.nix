{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.mrhappy200 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "video" "audio"] ++ ifTheyExist ["minecraft" "network" "wireshark" "i2c" "mysql" "docker" "git" "libvirtd"];

    openssh.authorizedKeys.keys = [(builtins.readFile ../../../../home/mrhappy200/ssh.pub)];
    hashedPasswordFile = config.sops.secrets.mrhappy200-password.path;
    #initialPassword = "passwordtest";
    packages = [pkgs.home-manager];
  };

  sops.secrets.mrhappy200-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.mrhappy200 = import ../../../../home/mrhappy200/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
