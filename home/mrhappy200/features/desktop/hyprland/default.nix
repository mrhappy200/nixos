{
  lib,
  config,
  pkgs,
  ...
}:
let
  getHostname = x: lib.last (lib.splitString "@" x);
  defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
  uwsm = "${lib.getExe pkgs.uwsm} app -s a -t service --";
in
{
  imports = [
    ../common
    ../common/wayland-wm
    ./basic-binds.nix
    ./hyprpaper.nix
    ./quickshell
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # get it from the nixos module. Less modularised but should work better
    systemd.enable = false;

    settings = {
      general = {
        # Misterio
        #gaps_in = 3.5;
        #gaps_out = 6;
        #border_size = 2;

        # Gaps and border
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;

        border_size = 1;
        resize_on_border = true;

        no_focus_fallback = true;

        allow_tearing = true; # This just allows the `immediate` window rule to work

        snap = {
          enabled = true;
        };
      };

      cursor = {
        inactive_timeout = 4;
        zoom_factor = 1;
        zoom_rigid = false;
      };

      group = {
        groupbar.font_size = 11;
      };

      binds = {
        movefocus_cycles_fullscreen = false;
        scroll_event_delay = 0;
        hide_special_on_workspace_change = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "altwin:swap_alt_win, compose:ralt";
      };

      dwindle = {
        split_width_multiplier = 1.35;
        pseudotile = true;
      };

      #gestures = {
      #  workspace_swipe = true;
      #  workspace_swipe_min_speed_to_force = 10;
      #  workspace_swipe_forever = true;
      #};

      misc = {
        vfr = true;
        # 1 = always, 2 = only on fullscreen
        vrr = 1;
        close_special_on_empty = true;
        focus_on_activate = true;
        on_focus_under_fullscreen = 1;
        disable_hyprland_logo = true;
        enable_swallow = true;
        swallow_regex = "(?i)(${
          lib.concatMapStringsSep "|" (lib.removeSuffix ".desktop")
            config.xdg.mimeApps.defaultApplications."x-scheme-handler/terminal"
        })";
      };

      windowrule =
        let
          steamGame = "steam_app_[0-9]*";
          kdeconnect-pointer = "org.kdeconnect.daemon";
          wineTray = "explorer.exe";
          steamBigPicture = "Steam Big Picture Mode";
          androidStudio-hover = "^jetbrains-(?!toolbox)";
        in
        [
          {
            name = "layerrule-1";
            "match:fullscreen_state_internal" = "2";
            "match:fullscreen_state_client" = "*";
            idle_inhibit = "focus";
          }
          {
            name = "layerrule-2";
            "match:class" = steamGame;
            immediate = true;
          }
          {
            name = "layerrule-3";
            "match:class" = kdeconnect-pointer;
            size = "100% 100%";
            float = true;
            no_focus = true;
            no_blur = true;
            no_anim = true;
            no_shadow = true;
            border_size = "0";
            suppress_event = "fullscreen";
          }
          {
            name = "layerrule-4";
            "match:class" = wineTray;
            workspace = "special silent";
          }
          {
            name = "layerrule-5";
            "match:title" = steamBigPicture;
            fullscreen = true;
          }
          {
            name = "layerrule-6";
            "match:class" = androidStudio-hover;
            "match:float" = 1;
            "match:title" = "^win\\d+$";
            no_focus = true;
          }
        ];

      #windowrulev2 =
      #  let
      #    steamGame = "class:steam_app_[0-9]*";
      #    kdeconnect-pointer = "class:org.kdeconnect.daemon";
      #    wineTray = "class:explorer.exe";
      #    steamBigPicture = "title:Steam Big Picture Mode";
      #    androidStudio-hover = "class:^jetbrains-(?!toolbox)";
      #  in
      #  [
      #    "idleinhibit focus, fullscreenstate:2 *"
      #    #        "nofocus, ${sweethome3d-tooltips}"

      #    "immediate, ${steamGame}"

      #    "size 100% 100%, ${kdeconnect-pointer}"
      #    "float, ${kdeconnect-pointer}"
      #    "nofocus, ${kdeconnect-pointer}"
      #    "noblur, ${kdeconnect-pointer}"
      #    "noanim, ${kdeconnect-pointer}"
      #    "noshadow, ${kdeconnect-pointer}"
      #    "noborder, ${kdeconnect-pointer}"
      #    "plugin:hyprbars:nobar, ${kdeconnect-pointer}"
      #    "suppressevent fullscreen, ${kdeconnect-pointer}"

      #    "workspace special silent, ${wineTray}"

      #    "fullscreen, ${steamBigPicture}"

      #    "nofocus, ${androidStudio-hover}, floating:1,title:^win\\d+$"
      #  ];
      layerrule = [
        "animation fade, match:namespace hyprpicker"
        "animation fade, match:namespace selection"
        "animation fade, match:namespace hyprpaper"
        "blur on, ignore_alpha 0, match:namespace notifications"
        "no_anim on, match:namespace wallpaper"
      ];

      decoration = {
        rounding = 18;

        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 14;
          passes = 3;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
          input_methods = true;
          input_methods_ignorealpha = 0.8;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          range = 30;
          offset = "0 2";
          render_power = 4;
        };

        # Dim
        dim_inactive = true;
        dim_strength = 0.025;
        dim_special = 0.07;
      };

      animations = {
        enabled = true;
        # Curves
        bezier = [
          "expressiveFastSpatial, 0.42, 1.67, 0.21, 0.90"
          "expressiveSlowSpatial, 0.39, 1.29, 0.35, 0.98"
          "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
          "emphasizedDecel, 0.05, 0.7, 0.1, 1"
          "emphasizedAccel, 0.3, 0, 0.8, 0.15"
          "standardDecel, 0, 0, 0, 1"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.52, 0.03, 0.72, 0.08"
        ];
        animation = [
          # Configs
          # windows
          "windowsIn, 1, 3, emphasizedDecel, popin 80%"
          "windowsOut, 1, 2, emphasizedDecel, popin 90%"
          "windowsMove, 1, 3, emphasizedDecel, slide"
          "border, 1, 10, emphasizedDecel"
          # layers
          "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
          "layersOut, 1, 2.4, menu_accel, popin 94%"
          # fade
          "fadeLayersIn, 1, 0.5, menu_decel"
          "fadeLayersOut, 1, 2.7, menu_accel"
          # workspaces
          "workspaces, 1, 7, menu_decel, slide"
          ## specialWorkspace
          "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
          "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
        ];
      };

      bind = [
        # Rename workspace
        "SUPER,r,exec,${pkgs.writeShellScript "rename" ''
          workspace="$(hyprctl activeworkspace -j)"
          id="$(jq -r .id <<< "$workspace")"
          prefix="$id - "
          name="$(jq -r .name <<< "$workspace")"
          name="''${name#"$prefix"}" # Remove prefix
          entry="$(GSK_RENDERER=cairo ${lib.getExe pkgs.zenity} --entry --title "Rename Workspace" --entry-text="$name")"
          if [ -z "$entry" ] || [ "$entry" == "$id" ]; then
            new_name="$id"
          else
            new_name="$prefix$entry"
          fi
          hyprctl dispatch renameworkspace "$id" "$new_name"
        ''}"
        # Program bindings
        "SUPER,Return,exec,${defaultApp "x-scheme-handler/terminal"}"
        "SUPER,e,exec,${defaultApp "text/plain"}"
        "SUPER,b,exec,${defaultApp "x-scheme-handler/https"}"
      ]
      ++
        # Launcher
        (
          let
            wofi = lib.getExe config.programs.wofi.package;
          in
          lib.optionals config.programs.wofi.enable [
            "SUPER,x,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
            "SUPER,s,exec,specialisation $(specialisation | ${wofi} -S dmenu)"
            "SUPER,d,exec,${wofi} -S run"
          ]
          ++ (
            let
              tofi = pkgs.tofi;
            in
            lib.optionals config.programs.tofi.enable [
              "SUPER,x,exec,${uwsm} $(${tofi}/bin/tofi-drun)"
              "SUPER,s,exec,specialisation $(specialisation | ${tofi}/bin/tofi)"
              "SUPER,d,exec,${tofi}/bin/tofi-run"
            ]
          )
          ++ (
            let
              pass-wofi = lib.getExe (
                pkgs.pass-wofi.override {
                  pass = config.programs.password-store.package;
                }
              );
            in
            lib.optionals config.programs.password-store.enable [
              ",XF86Calculator,exec,${pass-wofi}"
              "SHIFT,XF86Calculator,exec,${pass-wofi} fill"

              "SUPER,semicolon,exec,${pass-wofi}"
              "SHIFTSUPER,semicolon,exec,${pass-wofi} fill"
            ]
          )
          ++ (
            let
              cliphist = lib.getExe config.services.cliphist.package;
            in
            lib.optionals config.services.cliphist.enable [
              ''SUPER,c,exec,selected=$(${cliphist} list | ${wofi} -S dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
            ]
          )
          ++ (
            let
              # Save to image and share it to device, if png; else share as text to clipboard.
              share-kdeconnect = lib.getExe (
                pkgs.writeShellScriptBin "kdeconnect-share" ''
                  type="$(wl-paste -l | head -1)"
                  device="$(kdeconnect-cli -a --id-only | head -1)"
                  if [ "$type" == "image/png" ]; then
                    path="$(mktemp XXXXXXX.png)"
                    wl-paste > "$path"
                    output="$(kdeconnect-cli --share "$path" -d "$device")"
                  else
                    output="$(kdeconnect-cli --share-text "$(wl-paste)" -d "$device")"
                  fi
                  notify-send -i kdeconnect "$output"
                ''
              );
            in
            lib.optionals config.services.kdeconnect.enable [ "SUPER,v,exec,${share-kdeconnect}" ]
          )
        );

      monitor =
        let
          waybarSpace =
            let
              inherit (config.wayland.windowManager.hyprland.settings.general)
                gaps_in
                gaps_out
                ;
              inherit (config.programs.waybar.settings.primary)
                position
                height
                width
                ;
              gap = gaps_out - gaps_in;
            in
            {
              top = if (position == "top") then height + gap else 0;
              bottom = if (position == "bottom") then height + gap else 0;
              left = if (position == "left") then width + gap else 0;
              right = if (position == "right") then width + gap else 0;
            };
        in
        [
          #",addreserved,${toString waybarSpace.top},${toString waybarSpace.bottom},${toString waybarSpace.left},${toString waybarSpace.right}"
        ]
        ++ (map (
          m:
          "${m.name},${
            if m.enabled then
              "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},${m.scale},bitdepth,${toString m.bitdepth}"
            else
              "disable"
          }"
        ) (config.monitors));

      workspace = map (m: "${m.workspace},monitor:${m.name}") (
        lib.filter (m: m.enabled && m.workspace != null) config.monitors
      );
    };

    # This is order sensitive, so it has to come here.
    extraConfig = ''
      debug:disable_logs = false
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
#uwsm app -- "$(D=$(wofi --show drun --define=drun-print_desktop_file=true); case "$D" in *'.desktop '*) echo "${D%.desktop *}.desktop:${D#*.desktop }";; *) echo "$D";; esac)"
