{
  pkgs,
  inputs,
  ...
}: let
in {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/mrhappy200

    ../common/optional/peripherals.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/systemd-boot.nix
    #    ../common/optional/lxd.nix
    ../common/optional/virtualisation.nix
    ../common/optional/polkit.nix

    ../common/optional/starcitizen-fixes.nix
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  environment.systemPackages = with pkgs; [
    #openai-whisper
    (whisper-cpp.override {
      rocmSupport = true;
      vulkanSupport = false;
      rocmGpuTargets = "gfx1200;gfx1201";
    })
    hello
  ];

  networking = {
    hostName = "euphrosyne";
    useDHCP = true;
  };

  #  nixpkgs.config.rocmSupport = true;

  nixpkgs.config.permittedInsecurePackages = [
                 "libsoup-2.74.3"
               ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # services.ollama = {
  #   enable = false;
  #   host = "0.0.0.0";
  #   openFirewall = true;
  #   models = "/persist/ollama/models";
  #   acceleration = "rocm";
  #   user = "ollama";
  #   loadModels = ["PetrosStav/gemma3-tools:12b"];
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  boot.loader.grub.enable = false;

  boot = {
    #    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
  };

  system.stateVersion = "22.05";
}
