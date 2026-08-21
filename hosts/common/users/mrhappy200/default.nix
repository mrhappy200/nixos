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
      "gamemode"
      "pipewire"
      "lxd"
      "minecraft"
      "flatpak"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "tss"
      "lpadmin"
      "lp"
      "scannner"
      "video"
      "wheel"
      "screen"
      "wireshark"
      "dialout"
    ];

    openssh.authorizedKeys.keys =
      (lib.splitString "\n" (builtins.readFile ../../../../home/mrhappy200/ssh.pub))
      ++ (lib.splitString "\n" (builtins.readFile ../../../../home/mrhappy200/phonekey.pub))
      ++ (lib.splitString "\n" (builtins.readFile ../../../../home/mrhappy200/guac.pub));
    hashedPasswordFile = config.sops.secrets.mrhappy200-password.path;
    #password = "123";
    packages = with pkgs; [
      home-manager
      #lutris
      #bottles
      #vulkan-loader
      #dxvk
      winetricks
      #freetype
      #android-studio
      #wineWow64Packages.waylandFull
    ];
  };

  # Disable to build for pve-nix-vm-1

  specialisation = {
    theme-light.configuration = {
      custom-stylix.theme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";
    };
    theme-dark.configuration = {
      custom-stylix.theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
  custom-stylix = {
    enable = true;
    cachebuster = "9"; # bump to force rebuild
    width = 2560;
    height = 1440;
    # svgTemplate defaults to ./BenBulben.svg.template
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control,esc)";
          esc = "capslock";
          rightshift = "layer(alt)";
        };
      };
    };
  };

  #environment.persistence = {"/nix/persist".directories = ["/home/mrhappy200/.local/share/bottles"];};

  hardware.rtl-sdr.enable = true;

  environment.persistence."/persist".users.mrhappy200 = {
    directories = [
      #    "Android"
      #    "AndroidStudioProjects"
      ".local/share/PrismLauncher"
    ];
  };

  sops.secrets.mrhappy200-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
  sops.secrets.mrhappy200-password-md5 = {
    sopsFile = ../../secrets.yaml;
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

  xdg = {
    portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
      ];

      config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    #portalPackage =
    #  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    package = pkgs.stable.hyprland;
    portalPackage = pkgs.stable.xdg-desktop-portal-hyprland;
  };

  home-manager.users.mrhappy200 = import ../../../../home/mrhappy200/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = { };
    hyprlock = { };
  };
}
