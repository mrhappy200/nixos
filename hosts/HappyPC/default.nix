{
  pkgs,
  lib,
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

    ../common/optional/podman.nix

    ../common/optional/pipewire.nix
    ../common/optional/virt
    ../common/optional/waydroid.nix
    #    ../common/optional/sunshine.nix
    ../common/optional/quietboot.nix
    ./services
    ../common/optional/wireless.nix
    ../common/optional/steam.nix
    ../common/optional/bluetooth.nix
    #../common/optional/guacamole
    ../common/optional/nginx.nix
    ../common/optional/acme.nix
    ../common/optional/systemd-boot.nix
  ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  };

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
    };
  };

  networking = {
    hostName = "HappyPC";
    dhcpcd.enable = true;
  };

  boot = {
    # kernelPackages =
    # pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = ["aarch64-linux" "x86_64-windows"];

    #loader.systemd-boot.enable = lib.mkForce false;
    #lanzaboote = {
    #  enable = true;
    #  pkiBundle = "/nix/persist/etc/secureboot";
    #};
  };

  programs = {
    adb.enable = true;
    dconf.enable =
      true;
    kdeconnect.enable = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
