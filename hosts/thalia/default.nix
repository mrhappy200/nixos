{
  pkgs,
  inputs,
  lib,
  ...
}:
let
in
{
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-x1-yoga-7th-gen
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix

    ../common/global
    ../common/users/mrhappy200
    ../common/users/mrhappy200/inkscape-binds

    ./disk-config.nix
    ../common/optional/ephemeral-btrfs.nix

    ../common/optional/peripherals.nix
    ../common/optional/trackpoint.nix
    ../common/optional/rotate-hyprland.nix
    ../common/optional/powermanagement.nix
    ../common/optional/fingerprint.nix
    #../common/optional/face_rec.nix
    ../common/optional/flatpak.nix
    #../common/optional/greetd.nix
    ../common/optional/gdm.nix
    ../common/optional/pipewire.nix
    ../common/optional/udisks.nix
    ../common/optional/gamemode.nix
    ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/locate.nix
    ../common/optional/stylix
    ../common/optional/systemd-boot.nix
    ../common/optional/secure-boot.nix
    ../common/optional/polkit.nix
  ];

  services.flatpak.update.onActivation = true;
  services.flatpak.enable = true;

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.openbox.enable = true;

  environment.systemPackages = with pkgs; [
    openbox
    obconf
    tint2
    rxvt-unicode
    #openai-whisper
    hello
    #bottles
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.ipp-usb.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      cups-brother-dcp1610wlpr
      hplipWithPlugin
      gutenprint
      gutenprintBin

    ];
  };

  networking = {
    hostName = "thalia";
    useDHCP = true;
  };

  services.lact = {
    enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      SDL2
      SDL2_image
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilwm # libxcb-icccm
      xorg.xcbutilimage # libxcb-image
      xorg.xcbutilkeysyms # libxcb-keysyms
      xorg.xcbutilrenderutil # libxcb-render-util
    ];
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  boot.loader.grub.enable = false;

  boot = {
    #    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  programs = {
    dconf.enable = true;
  };

  system.stateVersion = "22.05";
}
