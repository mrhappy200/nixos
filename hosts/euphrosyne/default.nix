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

    ../common/global
    ./hardware-configuration.nix

    ../common/global/ssh-serve-store.nix
    ../common/users/mrhappy200

    ../common/users/mrhappy200/inkscape-binds

    ../common/optional/peripherals.nix
    ../common/optional/rgb.nix
    ../common/optional/weechat.nix
    ../common/optional/ssh-serve-store.nix
    ../common/optional/guacamole.nix
    ../common/optional/arr
    ../common/optional/flatpak.nix
    ../common/optional/ollama.nix
    ../common/optional/nginx.nix
    ../common/optional/acme.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    #../common/optional/windows
    ../common/optional/udisks.nix
    ../common/optional/gamemode.nix
    ../common/optional/quietboot.nix
    ../common/optional/wireless.nix
    ../common/optional/locate.nix
    #../common/optional/vr.nix
    ../common/optional/stylix
    ../common/optional/systemd-boot.nix
    #    ../common/optional/lxd.nix
    ../common/optional/virtualisation.nix
    ../common/optional/polkit.nix

    ../common/optional/starcitizen-fixes.nix
    #../common/optional/docker.nix
  ];

  services.flatpak.update.onActivation = true;
  services.flatpak.enable = true;

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    tuned.enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;

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
    android-tools
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
      # Moondeckbuddy
      59999

      6600
      10300
      10200
    ];
  };
  services.wyoming = {
    faster-whisper.servers = {
      "EuphrosyneWhisper" = {
        enable = true;
        # Set to 'auto' for normal whisper models
        sttLibrary = "sherpa";
        model = "sherpa-onnx-nemo-parakeet-tdt-0.6b-v3-int8";
        #model = "nvidia/parakeet-tdt-0.6b-v3";
        #model = "turbo";
        #model = "tiny-int8";
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
    hostName = "euphrosyne";
    #useDHCP = true;
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
    settings = {
      "capture" = "wlr";
      "output_name" = "2";
    };
    applications = {
      apps = [
        {
          "name" = "Desktop";
          "image-path" = "desktop.png";
        }
        {
          "name" = "Headless";
          "image-path" = "desktop.png";
          "prep-cmd" = [

            {
              "do" =
                "sh -c \"hyprctl keyword monitor HEADLESS-2,\$\{SUNSHINE_CLIENT_WIDTH\}x\$\{SUNSHINE_CLIENT_HEIGHT\}@\$\{SUNSHINE_CLIENT_FPS\},auto,1\"";
              "undo" = "hyprctl keyword monitor HEADLESS-2,disable";
            }
            {
              "do" = "hyprctl dispatch focusmonitor HEADLESS-2";
              "undo" = "hyprctl dispatch focusmonitor DP-3";
            }
          ];
        }
        {
          "name" = "Headless Steam";
          "image-path" = "steam.png";
          "prep-cmd" = [
            {
              "do" =
                "sh -c \"hyprctl keyword monitor HEADLESS-2,\$\{SUNSHINE_CLIENT_WIDTH\}x\$\{SUNSHINE_CLIENT_HEIGHT\}@\$\{SUNSHINE_CLIENT_FPS\},auto,1\"";
              "undo" = "hyprctl keyword monitor HEADLESS-2,disable";
            }
            {
              "do" = "hyprctl dispatch focusmonitor HEADLESS-2";
              "undo" = "hyprctl dispatch focusmonitor DP-3";
            }
            { "undo" = "setsid steam steam://close/bigpicture"; }
          ];
          "detached" = [
            "setsid steam steam://open/bigpicture"
          ];
        }
        {
          name = "MoonDeckStream";
          "prep-cmd" = [
            {
              "do" =
                "sh -c \"hyprctl keyword monitor HEADLESS-2,\$\{SUNSHINE_CLIENT_WIDTH\}x\$\{SUNSHINE_CLIENT_HEIGHT\}@\$\{SUNSHINE_CLIENT_FPS\},auto,1\"";
              "undo" = "hyprctl keyword monitor HEADLESS-2,disable";
            }
            {
              "do" = "hyprctl dispatch focusmonitor HEADLESS-2";
              "undo" = "hyprctl dispatch focusmonitor DP-3";
            }

          ];
          cmd = "${pkgs.moondeck-buddy}/bin/MoonDeckStream";
          exclude-global-prep-cmd = "false";
          elevated = "false";
        }
      ];
    };
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
  hardware.graphics.extraPackages = [ pkgs.amf ];

  boot.loader.grub.enable = false;

  boot = {
    #    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv7l-linux"
      "i686-linux"
      "x86_64-windows"
    ];
  };

  programs = {
    dconf.enable = true;
  };

  system.stateVersion = "22.05";
}
