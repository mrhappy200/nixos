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
    extraGroups = ["wheel" "dialout" "video" "audio" "plugdev"] ++ ifTheyExist ["minecraft" "network" "wireshark" "i2c" "mysql" "docker" "git" "libvirtd" "tss"];

    openssh.authorizedKeys.keys = [(builtins.readFile ../../../../home/mrhappy200/ssh.pub)];
    hashedPasswordFile = config.sops.secrets.mrhappy200-password.path;
    #initialPassword = "passwordtest";
    packages = [pkgs.home-manager];
  };

  sops.secrets.mrhappy200-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    swaylock.u2fAuth = true;
  };

  services.pcscd.enable = true;

  services.udev.packages = [pkgs.yubikey-personalization];

  home-manager.users.mrhappy200 = import ../../../../home/mrhappy200/${config.networking.hostName}.nix;

  services.fwupd.enable = true;
}
