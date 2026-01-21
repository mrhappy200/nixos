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
    ../common/optional/locate.nix
    ../common/optional/systemd-boot.nix
    #    ../common/optional/lxd.nix
    ../common/optional/virtualisation.nix
    ../common/optional/polkit.nix

    ../common/optional/starcitizen-fixes.nix
    ../common/optional/docker.nix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = ./BenBulben.png;
  };

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    tuned.enable = true;
  };

  virtualisation.podman.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    #openai-whisper
    hello
    bottles
    android-tools
    wlx-overlay-s
  ];

  networking = {
    hostName = "euphrosyne";
    useDHCP = true;
  };

  #systemd.tmpfiles.rules = [
  #  # Directory for snapserver runtime data
  #  "d /run/snapserver 0755 snapserver snapserver -"

  #  # FIFO shared between user MPD and system snapserver
  #  "p /run/snapserver/snapfifo 0666 - - -"
  #];

  networking.firewall = {
    allowedTCPPorts = [ 6600 ];
  };

  # Snapcast music server
  services.snapserver = {
    enable = true;
    openFirewall = true;
    settings = {
      stream.source = [
        "pipe:///run/snapserver/snapfifo?name=mpd&sampleformat=44100:16:2&codec=flac"
        "file:///example.wav?name=test"
        "pipe:///run/snapserver/pipewire?name=Euphrosyne&codec=flac"
      ];
      tcp-control = {
        enabled = true;
      };
      tcp-streaming = {
        enabled = true;
      };
      http = {
        enabled = true;
      };
    };
  };
  systemd.user.services.snapcast-sink = {
    wantedBy = [
      "pipewire.service"
    ];
    after = [
      "pipewire.service"
    ];
    bindsTo = [
      "pipewire.service"
    ];
    path = with pkgs; [
      gawk
      pulseaudio
    ];
    script = ''
      pactl load-module module-pipe-sink file=/run/snapserver/pipewire sink_name=Snapcast format=s16le rate=48000
      pactl load-module module-loopback source=$(pactl get-default-sink).monitor sink=Snapcast
    '';
  };

  services.wivrn = {
    enable = true;
    package = pkgs.wivrn;
    steam.importOXRRuntimes = true;
    openFirewall = true;
    defaultRuntime = true;
    highPriority = true;
    autoStart = true;
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
    dconf.enable = true;
  };

  system.stateVersion = "22.05";
}
