{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.mrhappy200 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "deluge"
      "docker"
      "git"
      "i2c"
      "weechat"
      "libvirtd"
      "lxd"
      "minecraft"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "tss"
      "video"
      "wheel"
      "screen"
      "wireshark"
      "dialout"
    ];

    openssh.authorizedKeys.keys = lib.splitString "\n" (
      builtins.readFile ../../../../home/mrhappy200/ssh.pub
    );
    hashedPasswordFile = config.sops.secrets.mrhappy200-password.path;
    #password = "123";
    packages = with pkgs; [
      home-manager
      lutris
      bottles
      vulkan-loader
      dxvk
      winetricks
      freetype
      android-studio
      wineWowPackages.waylandFull
    ];
  };

  #environment.persistence = {"/nix/persist".directories = ["/home/mrhappy200/.local/share/bottles"];};

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];

  imports = [
    inputs.noctalia.nixosModules.default
  ];
  services.noctalia-shell.enable = true;

  services.weechat = {
    enable = true;
  };
  # This allows other users to access the weechat screen session with the following command
  # screen -x weechat/weechat-screen
  programs.screen.screenrc = ''
    multiuser on
    acladd mrhappy200
  '';
  users.users.weechat = {
    isSystemUser = true;
    description = "Weechat system user";
    home = "/var/lib/weechat";
    createHome = true;
    shell = "${pkgs.shadow}/bin/nologin";
  };

  environment.persistence."/persist".directories = [ "/var/lib/weechat" ];

  environment.persistence."/persist".users.mrhappy200 = {
    directories = [
      "Android"
      "AndroidStudioProjects"
      ".local/share/PrismLauncher"
    ];
  };

  sops.secrets.mrhappy200-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  home-manager.users.mrhappy200 = import ../../../../home/mrhappy200/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = { };
    hyprlock = { };
  };
}
