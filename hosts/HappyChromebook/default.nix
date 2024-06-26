{
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix

    ../common/global
    ../common/users/mrhappy200

    ../common/optional/pipewire.nix
    #   ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/systemd-boot.nix

    ./disk-config.nix
  ];

  stylix.image = pkgs.fetchurl {
    url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/gruv-portal-cake.png";
    sha256 = "sha256-vb5mfQR2tyHwYRjVMAOGycIOhmlp7wgE1+skW/tuMKg=";
  };

  #users.users."mrhappy200".initialPassword = "passwordtest";

  #networking.wireless.networks = lib.mkForce {};
  #networking.wireless.environmentFile = lib.mkForce null;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["DejaVuSansMono"];};
      name = "DejaVuSansM Nerd Font";
    };
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking = {
    hostName = "HappyChromebook";
    useDHCP =
      true;
  };

  boot = {
    # kernelPackages =
    # pkgs.linuxKernel.packages.linux_zen;
    # binfmt.emulatedSystems = [ "aarch64-linux"
    # "i686-linux" ];
  };

  programs = {
    adb.enable = true;
    dconf.enable =
      true;
    kdeconnect.enable = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
