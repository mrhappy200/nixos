{ pkgs, inputs, ... }:
let
in
{
  home.packages = with pkgs; [
    material-symbols
    inter
    fira-code
    inotify-tools
    cava
    wl-clipboard
    cliphist
    ddcutil
    libsForQt5.qt5ct
    kdePackages.qt6ct
    matugen
    inputs.dgop.packages.${pkgs.system}.dgop
    inputs.caelestia-cli.packages.${pkgs.system}.caelestia-cli
    inputs.caelestia.packages.${pkgs.system}.caelestia-shell
    brightnessctl
    app2unit
    cava
    networkmanager
    lm_sensors
    aubio
    pipewire
    glibc
    kdePackages.qtdeclarative
    libgcc
    nerd-fonts.caskaydia-cove
    grim
    swappy
    libqalculate
  ];
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.system}.default;
    activeConfig = "caelestia";
    configs = {
      dank = "${inputs.dankMaterialShell}";
      iimpulse = "${inputs.illogical-impulse}/.config/quickshell/ii";
      caelestia = "${inputs.caelestia}";
    };
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  xdg.configFile."caelestia/shell.json".text = ''
      	{
        "appearance": {
            "anim": {
                "durations": {
                    "scale": 1
                }
            },
            "font": {
                "family": {
                    "material": "Material Symbols Rounded",
                    "mono": "CaskaydiaCove NF",
                    "sans": "Rubik"
                },
                "size": {
                    "scale": 1
                }
            },
            "padding": {
                "scale": 1
            },
            "rounding": {
            	"scale": 1
            },
            "spacing": {
                "scale": 1
            },
            "transparency": {
                "enabled": false,
                "base": 0.85,
                "layers": 0.4
            }
        },
        "general": {
            "apps": {
                "terminal": ["foot"],
                "audio": ["pavucontrol"]
            }
        },
        "background": {
            "desktopClock": {
                "enabled": true
            },
            "enabled": true
        },
        "bar": {
            "dragThreshold": 20,
            "entries": [
            	{
       	            "id": "logo",
       	            "enabled": true
       	        },
       	        {
       	            "id": "workspaces",
       	            "enabled": true
       	        },
       	        {
       	            "id": "spacer",
       	            "enabled": true
       	        },
       	        {
       	            "id": "activeWindow",
       	            "enabled": true
       	        },
       	        {
       	            "id": "spacer",
       	            "enabled": true
       	        },
       	        {
       	            "id": "tray",
       	            "enabled": true
       	        },
       	        {
       	            "id": "clock",
       	            "enabled": true
       	        },
       	        {
       	            "id": "statusIcons",
       	            "enabled": true
       	        },
       	        {
       	            "id": "power",
       	            "enabled": false
       	        },
       	        {
       	            "id": "idleInhibitor",
       	            "enabled": true
       	        }
            ],
            "persistent": true,
            "showOnHover": true,
            "status": {
                "showAudio": true,
                "showBattery": false,
                "showBluetooth": true,
                "showKbLayout": true,
                "showNetwork": true
            },
            "tray": {
                "background": false,
                "recolour": false
            },
            "workspaces": {
                "activeIndicator": true,
                "activeLabel": "󰮯",
                "activeTrail": false,
                "label": "  ",
                "occupiedBg": false,
                "occupiedLabel": "󰮯",
                "perMonitorWorkspaces": true,
                "showWindows": true,
                "shown": 5
            }
        },
        "border": {
            "rounding": 25,
            "thickness": 10
        },
        "dashboard": {
            "enabled": true,
            "dragThreshold": 50,
            "mediaUpdateInterval": 500,
            "showOnHover": true,
            "visualiserBars": 45
        },
        "launcher": {
            "actionPrefix": ";",
            "dragThreshold": 50,
            "vimKeybinds": true,
            "enableDangerousActions": false,
            "maxShown": 8,
            "maxWallpapers": 9,
            "specialPrefix": "@",
            "useFuzzy": {
                "apps": true,
                "actions": false,
                "schemes": false,
                "variants": false,
                "wallpapers": false
            }
        },
        "lock": {
            "recolourLogo": false
        },
        "notifs": {
            "actionOnClick": false,
            "clearThreshold": 0.3,
            "defaultExpireTimeout": 5000,
            "expandThreshold": 20,
            "expire": false
        },
        "osd": {
            "hideDelay": 2000
        },
        "paths": {
            "mediaGif": "root:/assets/bongocat.gif",
            "sessionGif": "root:/assets/kurukuru.gif",
            "wallpaperDir": "~/Pictures/Wallpapers"
        },
        "services": {
            "audioIncrement": 0.1,
            "defaultPlayer": "Spotify",
            "playerAliases": [{
                "com.github.th_ch.youtube_music": "YT Music"
            }],
            "weatherLocation": "10,10",
            "useFahrenheit": false,
            "useTwelveHourClock": false,
            "smartScheme": true
        },
        "session": {
            "dragThreshold": 30,
            "vimKeybinds": true,
            "commands": {
                "logout": ["loginctl", "terminate-user", ""],
                "shutdown": ["systemctl", "poweroff"],
                "hibernate": ["systemctl", "hibernate"],
                "reboot": ["systemctl", "reboot"]
            }
        }
    }
  '';
}
