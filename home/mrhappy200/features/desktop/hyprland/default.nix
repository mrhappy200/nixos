{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [../common ../common/wayland-wm ./basic-binds.nix];

  home.packages = [pkgs.inputs.hyprwm-contrib.grimblast pkgs.hyprpicker];

  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    plugins = [];

    # systemd = {
    #   enable = false;
    #   # Same as default, but stop graphical-session too
    #   extraCommands = lib.mkBefore [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };

    settings = let
      uwsm = "${pkgs.uwsm}/bin/uwsm";
    in {
      general = {
        gaps_in = 2;
        gaps_out = 3;
        border_size = 2;
      };
      group = {groupbar.font_size = 11;};
      binds = {movefocus_cycles_fullscreen = false;};
      input = {
        kb_layout = "us";
        touchpad.disable_while_typing = false;
      };

      device = [
        {
          name = "lizhi-flash-ic-usb-keyboard";
          kb_options = "altwin:swap_alt_win, compose:ralt";
        }

        {
          name = "hid-27c0:0818";
          output = "HDMI-A-1";
        }
        {
          name = "wacom-bamboo-2fg-6x8-pen";
          output = "eDP-1";
        }
      ];

      dwindle = {
        split_width_multiplier = 1.35;
        pseudotile = true;
      };
      misc = {
        vfr = true;
        close_special_on_empty = true;
        focus_on_activate = true;
        # Unfullscreen when opening something
        new_window_takes_over_fullscreen = 2;
      };
      windowrulev2 = let
        sweethome3d-tooltips = "title:^(win[0-9])$,class:^(com-eteks-sweethome3d-SweetHome3DBootstrap)$";
        steam = "title:^()$,class:^(steam)$";
        kdeconnect-pointer = "class:^(kdeconnect.daemon)$";
      in [
        "nofocus, ${sweethome3d-tooltips}"

        "stayfocused, ${steam}"
        "minsize 1 1, ${steam}"

        "size 100% 110%, ${kdeconnect-pointer}"
        "center, ${kdeconnect-pointer}"
        "nofocus, ${kdeconnect-pointer}"
        "noblur, ${kdeconnect-pointer}"
        "noanim, ${kdeconnect-pointer}"
        "noshadow, ${kdeconnect-pointer}"
        "noborder, ${kdeconnect-pointer}"
        "suppressevent fullscreen, ${kdeconnect-pointer}"
      ];
      layerrule = [
        "animation fade,waybar"
        "blur,waybar"
        "ignorezero,waybar"
        "blur,notifications"
        "ignorezero,notifications"
        "blur,wofi"
        "ignorezero,wofi"
        "noanim,wallpaper"
      ];

      decoration = {
        active_opacity = 0.97;
        inactive_opacity = 0.77;
        fullscreen_opacity = 1.0;
        rounding = 7;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 12;
          offset = "3 3";
        };
      };
      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinout,0.45, 0, 0.55, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
          "easeinoutback,0.68, -0.6, 0.32, 1.6"
        ];

        animation = [
          "border,1,3,easeout"
          "workspaces,1,2,easeoutback,slide"
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeinout"
          "fadeShadow,1,3,easeinout"
          "fadeDim,1,3,easeinout"
          "fadeLayersIn,1,3,easeoutback"
          "fadeLayersOut,1,3,easeinback"
          "layersIn,1,3,easeoutback,slide"
          "layersOut,1,3,easeinback,slide"
        ];
      };

      exec = ["${uwsm} app -- ${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} --mode fill"];
      exec-once = ["lxqt.lxqt-policykit"];

      bind = let
        grimblast = lib.getExe pkgs.inputs.hyprwm-contrib.grimblast;
        tesseract = lib.getExe pkgs.tesseract;
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
        notify-send = lib.getExe' pkgs.libnotify "notify-send";
        defaultApp = type: "${uwsm} app -- $(${lib.getExe pkgs.handlr-regex} get ${type})";
      in
        [
          # Program bindings
          "SUPER,Return,exec,${defaultApp "x-scheme-handler/terminal"}"
          "SUPER,e,exec,${defaultApp "text/plain"}"
          "SUPER,b,exec,${defaultApp "x-scheme-handler/https"}"
          # Brightness control (only works if the system has lightd)
          ",XF86MonBrightnessUp,exec,light -A 10"
          ",XF86MonBrightnessDown,exec,light -U 10"
          # Volume
          ",XF86AudioRaiseVolume,exec,${uwsm} app -- ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,${uwsm} app -- ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,${uwsm} app -- ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
          "SHIFT,XF86AudioMute,exec,${uwsm} app -- ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          ",XF86AudioMicMute,exec,${uwsm} app -- ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          # Screenshotting
          ",Print,exec,${uwsm} app -- ${grimblast} --notify --freeze copy output"
          "SUPER,Print,exec,${uwsm} app -- ${grimblast} --notify --freeze copy area"
          # To OCR
          "ALT,Print,exec,${uwsm} app -- ${grimblast} --freeze save area - | ${tesseract} - - | wl-copy && ${notify-send} -t 3000 'OCR result copied to buffer'"
        ]
        ++ (let
          playerctl = lib.getExe' config.services.playerctld.package "playerctl";
          playerctld =
            lib.getExe' config.services.playerctld.package "playerctld";
        in
          lib.optionals config.services.playerctld.enable [
            # Media control
            ",XF86AudioNext,exec,${uwsm} app -- ${playerctl} next"
            ",XF86AudioPrev,exec,${uwsm} app -- ${playerctl} previous"
            ",XF86AudioPlay,exec,${uwsm} app -- ${playerctl} play-pause"
            ",XF86AudioStop,exec,${uwsm} app -- ${playerctl} stop"
            "ALT,XF86AudioNext,exec,${uwsm} app -- ${playerctld} shift"
            "ALT,XF86AudioPrev,exec,${uwsm} app -- ${playerctld} unshift"
            "ALT,XF86AudioPlay,exec,${uwsm} app -- systemctl --user restart playerctld"
          ])
        ++
        # Screen lock
        (let
          swaylock = lib.getExe config.programs.swaylock.package;
        in
          lib.optionals config.programs.swaylock.enable [
            ",XF86Launch5,exec,${uwsm} app -- ${swaylock} -S --grace 2"
            ",XF86Launch4,exec,${uwsm} app -- ${swaylock} -S --grace 2"
            "SUPER,backspace,exec,${uwsm} app -- ${swaylock} -S --grace 2"
          ])
        ++
        # Notification manager
        (let
          makoctl = lib.getExe' config.services.mako.package "makoctl";
        in
          lib.optionals config.services.mako.enable [
            "SUPER,w,exec,${uwsm} app -- ${makoctl} dismiss"
            "SUPERSHIFT,w,exec,${uwsm} app -- ${makoctl} restore"
          ])
        ++
        # Launcher
        (let
          wofi = lib.getExe config.programs.wofi.package;
        in
          lib.optionals config.programs.wofi.enable [
            "SUPER,x,exec,${uwsm} app -- ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
            "SUPER,s,exec,${uwsm} app -- specialisation $(specialisation | ${wofi} -S dmenu)"
            "SUPERSHIFT,s,exec,${uwsm} app -- specialisation $(specialisation | shuf -n1)"

            "SUPER,d,exec,${uwsm} app -- ${wofi} -S run"
          ]
          ++ (let
            pass-wofi = lib.getExe (pkgs.pass-wofi.override {
              pass = config.programs.password-store.package;
            });
          in
            lib.optionals config.programs.password-store.enable [
              ",Scroll_Lock,exec,${uwsm} app -- ${pass-wofi}" # fn+k
              ",XF86Calculator,exec,${uwsm} app -- ${pass-wofi}" # fn+f12
              "SUPER,semicolon,exec,${uwsm} app -- ${pass-wofi}"
              "SHIFT,Scroll_Lock,exec,${uwsm} app -- ${pass-wofi} fill" # fn+k
              "SHIFT,XF86Calculator,exec,${uwsm} app -- ${pass-wofi} fill" # fn+f12
              "SHIFTSUPER,semicolon,exec,${uwsm} app -- ${pass-wofi} fill"
            ]));

      monitor = let
        inherit
          (config.wayland.windowManager.hyprland.settings.general)
          gaps_in
          gaps_out
          ;
        gap = gaps_out - gaps_in;
        inherit (config.programs.waybar.settings.primary) position height width;
        waybarSpace = {
          top =
            if (position == "top")
            then height + gap
            else 0;
          bottom =
            if (position == "bottom")
            then height + gap
            else 0;
          left =
            if (position == "left")
            then width + gap
            else 0;
          right =
            if (position == "right")
            then width + gap
            else 0;
        };
      in
        [
          ",addreserved,${toString waybarSpace.top},${
            toString waybarSpace.bottom
          },${toString waybarSpace.left},${toString waybarSpace.right}"
        ]
        ++ (map (m: "${m.name},${
          if m.enabled
          then "${toString m.width}x${toString m.height}@${
            toString m.refreshRate
          },${toString m.x}x${toString m.y},1"
          else "disable"
        }") (config.monitors));

      workspace =
        map (m: "${m.name},${m.workspace}")
        (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
    };
    # This is order sensitive, so it has to come here.
    extraConfig = ''
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
