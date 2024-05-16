{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-gpu-nvidia
    # inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix

    ../common/global
    ../common/users/mrhappy200

    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/steam.nix
    ../common/optional/guacamole
    ../common/optional/systemd-boot.nix
  ];

  stylix.image = pkgs.fetchurl {
    url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/gruv-portal-cake.png";
    sha256 = "sha256-vb5mfQR2tyHwYRjVMAOGycIOhmlp7wgE1+skW/tuMKg=";
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["DejaVuSansMono"];};
      name = "DejaVuSansM Nerd Font";
    };
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking = {
    hostName = "HappyPC";
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
