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
      wineWowPackages.stable
      winetricks
      android-studio
    ];
  };

  #environment.persistence = {"/nix/persist".directories = ["/home/mrhappy200/.local/share/bottles"];};

  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        # 1.0x foveation scaling
        scale = 1.0;
        # 100 Mb/s
        bitrate = 100000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            # 1.0 x 1.0 scaling
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
      };
    };
  };

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
