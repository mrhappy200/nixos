{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common/global
    ../common/users/mrhappy200

    ../common/optional/pipewire.nix
    ../common/optional/wireless.nix
    ../common/optional/bluetooth.nix
  ];

  stylix = {
    image = pkgs.fetchurl {
      url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/gruv-portal-cake.png";
      sha256 = "sha256-vb5mfQR2tyHwYRjVMAOGycIOhmlp7wgE1+skW/tuMKg=";
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["DejaVuSansMono"];};
        name = "DejaVuSansM Nerd Font";
      };
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
    enable = true;
  };
  fonts.packages = [pkgs.dm-sans pkgs.corefonts];

  networking = {
    hostName = "HappyRaspi";
    dhcpcd.enable = true;
  };

  boot = {
    # kernelPackages =
    # pkgs.linuxKernel.packages.linux_zen;

    #loader.systemd-boot.enable = lib.mkForce false;
    #lanzaboote = {
    #  enable = true;
    #  pkiBundle = "/nix/persist/etc/secureboot";
    #};
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
