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
    ../common/optional/guacamole.nix
    ../common/optional/ollama.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/windows
    ../common/optional/udisks.nix
    ../common/optional/gamemode.nix
    ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/locate.nix
    ../common/optional/stylix
    ../common/optional/systemd-boot.nix
    #    ../common/optional/lxd.nix
    ../common/optional/virtualisation.nix
    ../common/optional/polkit.nix

    ../common/optional/starcitizen-fixes.nix
    ../common/optional/docker.nix
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    tuned.enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;
  virtualisation.podman.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    #openai-whisper
    hello
    bottles
    android-tools
    wayvr
  ];

  #Calibre server
  services.calibre-server = {
    enable = false;
    host = "0.0.0.0";
    port = 8194;
    libraries = [ "/nix/persist/home/mrhappy200/Calibre\ Library" ];
    auth.enable = false;
  };

  # Wyoming for home assistant
  networking.firewall = {
    allowedTCPPorts = [
      6600
      10300
      10200
    ];
  };
  services.wyoming = {
    faster-whisper.servers = {
      "EuphrosyneWhisper" = {
        enable = true;
        #model = "turbo";
        model = "tiny-int8";
        language = "en";
        uri = "tcp://0.0.0.0:10300";
        #initialPrompt = ''
        #  Ronan,Max, and Lara are lovely names.
        #'';
      };
    };
    piper.servers."EuphrosynePiper" = {
      enable = true;
      zeroconf = {
        enable = true;
        name = "EuphrosynePiper";
      };
      voice = "en_GB-alba-medium";
      uri = "tcp://0.0.0.0:10200";
    };
  };
  systemd.services."wyoming-faster-whisper-EuphrosyneWhisper".serviceConfig = {
    DynamicUser = lib.mkForce false;
  };
  environment.persistence = {
    "/persist" = {
      directories = [
        {
          directory = "/var/lib/wyoming";
          user = "wyoming-faster-whisper";
        }
      ];
    };
  };
  users.users.wyoming-faster-whisper = {
    description = "whisper user";
    createHome = false;
    group = "wyoming-faster-whisper";
    isSystemUser = true;
  };
  users.groups.wyoming-faster-whisper = { };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      hplipWithPlugin
      gutenprint
      gutenprintBin
    ];
  };

  networking = {
    hostName = "euphrosyne";
    useDHCP = true;
  };

  services.lact = {
    enable = true;
  };

  #systemd.tmpfiles.rules = [
  #  # Directory for snapserver runtime data
  #  "d /run/snapserver 0755 snapserver snapserver -"

  #  # FIFO shared between user MPD and system snapserver
  #  "p /run/snapserver/snapfifo 0666 - - -"
  #];

  # Snapcast music server
  services.snapserver = {
    enable = true;
    openFirewall = true;
    settings = {
      stream.source = [
        "pipe:///run/snapserver/snapfifo?name=mpd&sampleformat=44100:16:2&codec=flac"
        #"file:///example.wav?name=test"
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

  # XRIZER didn't want to build
  #services.wivrn = {
  #  enable = true;
  #  package = pkgs.wivrn;
  #  steam.importOXRRuntimes = true;
  #  openFirewall = true;
  #  defaultRuntime = true;
  #  highPriority = true;
  #  autoStart = true;
  #};

  nixpkgs.config.rocmSupport = true;

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
      "x86_64-windows"
    ];
  };

  programs = {
    dconf.enable = true;
  };

  system.stateVersion = "22.05";
}
