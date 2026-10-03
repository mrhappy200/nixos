{
  lib,
  config,
  pkgs,
  ...
}:
let
  getHostname = x: lib.last (lib.splitString "@" x);
  uwsm = "${pkgs.uwsm}/bin/uwsm-app -s a -t service --";
  defaultApp = type: "${uwsm} $(${lib.getExe pkgs.stable.handlr-regex} get ${type})";
  grimblast = lib.getExe pkgs.grimblast;
in
{
  imports = [
    ../common
    ../common/wayland-wm
    ./dynamic-cursor.nix
    #    ./hyprfocus.nix
    #./split-monitor-workspaces.nix
    ./basic-binds.nix
    ./widgets.nix
    ./hyprpaper.nix
    ./noctalia-v5.nix
    ./hypridle.nix
    #./hyprlock.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null; # get it from the nixos module. Less modularised but should work better
    systemd.enable = false;
    settings = {
      config = {
        general = {
          gaps_in = 4;
          gaps_out = 5;
          gaps_workspaces = 50;

          border_size = 2;
          resize_on_border = true;

          no_focus_fallback = true;

          allow_tearing = true;

          snap = {
            enabled = true;
          };
        };

        cursor = {
          enable_hyprcursor = true;
          hide_on_key_press = true;
          inactive_timeout = 3;
          sync_gsettings_theme = true;

          persistent_warps = true;
          warp_on_change_workspace = true;
          warp_on_toggle_special = true;

          zoom_disable_aa = true;
        };

        quirks.prefer_hdr = 1;

        group = {
          auto_group = false;
          drag_into_group = 2;
        };

        binds = {
          movefocus_cycles_fullscreen = false;
          hide_special_on_workspace_change = true;
          focus_preferred_method = 1;
        };

        input = {
          kb_layout = "us";
          kb_options = "compose:ralt";
          numlock_by_default = true;
          special_fallthrough = true;
        };
        dwindle = {
          split_width_multiplier = 1.35;
        };

        gestures = {
          close_max_timeout = 500;
          workspace_swipe_direction_lock = false;
          workspace_swipe_forever = true;
          workspace_swipe_touch = true;
          scrolling = {
            move_snap_to_grid = true;
            move_snap_cursor = false;
          };
        };
        misc = {
          vrr = 1;
          close_special_on_empty = true;
          focus_on_activate = true;
          on_focus_under_fullscreen = 1;
        };

        decoration = {
          rounding = 18;
          blur = {
            enabled = true;
            brightness = 1.05;
            contrast = 1;
            noise = 0.03;
            passes = 4;
            size = 4;
            variant = "kawase";
            vibrancy = 0.08;
            vibrancy_darkness = 1;
            xray = false;

            popups = true;
            popups_ignorealpha = 0.6;
            input_methods = true;
            input_methods_ignorealpha = 0.8;

            special = true;
          };
          shadow = {
            enabled = true;
            range = 30;
            offset = "0 2";
            render_power = 4;
          };
          wobble = {
            enabled = true;
          };
          dim_inactive = true;
          dim_strength = 0.025;
          dim_special = 0.07;
        };
      };
      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 1;
          bezier = "standardDecel";
        }

        {
          leaf = "windowsIn";
          enabled = true;
          speed = 3;
          bezier = "emphasizedDecel";
          style = "popin 80%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 2;
          bezier = "emphasizedDecel";
          style = "popin 90%";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 3;
          bezier = "emphasizedDecel";
          style = "slide";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "emphasizedDecel";
        }

        {
          leaf = "layersIn";
          enabled = true;
          speed = 2.7;
          bezier = "emphasizedDecel";
          style = "popin 93%";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 2.4;
          bezier = "menu_accel";
          style = "popin 94%";
        }

        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 0.5;
          bezier = "menu_decel";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 2.7;
          bezier = "menu_accel";
        }

        {
          leaf = "workspaces";
          enabled = true;
          speed = 7;
          bezier = "menu_decel";
          style = "slide";
        }
        {
          leaf = "specialWorkspaceIn";
          enabled = true;
          speed = 2.8;
          bezier = "emphasizedDecel";
          style = "slidevert";
        }
        {
          leaf = "specialWorkspaceOut";
          enabled = true;
          speed = 1.2;
          bezier = "emphasizedAccel";
          style = "slidevert";
        }
      ];

      curve = [
        {
          _args = [
            "expressiveFastSpatial"
            {
              type = "bezier";
              points = [
                [
                  0.42
                  1.67
                ]
                [
                  0.21
                  0.90
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "expressiveSlowSpatial"
            {
              type = "bezier";
              points = [
                [
                  0.39
                  1.29
                ]
                [
                  0.35
                  0.98
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "expressiveDefaultSpatial"
            {
              type = "bezier";
              points = [
                [
                  0.38
                  1.21
                ]
                [
                  0.22
                  1.00
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "emphasizedDecel"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.7
                ]
                [
                  0.1
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "emphasizedAccel"
            {
              type = "bezier";
              points = [
                [
                  0.3
                  0
                ]
                [
                  0.8
                  0.15
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "standardDecel"
            {
              type = "bezier";
              points = [
                [
                  0
                  0
                ]
                [
                  0
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_decel"
            {
              type = "bezier";
              points = [
                [
                  0.1
                  1
                ]
                [
                  0
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_accel"
            {
              type = "bezier";
              points = [
                [
                  0.52
                  0.03
                ]
                [
                  0.72
                  0.08
                ]
              ];
            }
          ];
        }
      ];

    }
    // (
      let
        lua = lib.generators.mkLuaInline;

        mkBind = modifiers: key: command: {
          _args = [
            (if modifiers == "" then key else "${modifiers} + ${key}")
            (lua "hl.dsp.exec_cmd(${builtins.toJSON command})")
          ];
        };

        renameWorkspace = pkgs.writeShellScript "rename-workspace" ''
          workspace="$(hyprctl activeworkspace -j)"
          id="$(jq -r .id <<< "$workspace")"
          prefix="$id - "
          name="$(jq -r .name <<< "$workspace")"
          name="''${name#"$prefix"}"

          entry="$(
            GSK_RENDERER=cairo ${lib.getExe pkgs.zenity} \
              --entry \
              --title "Rename Workspace" \
              --entry-text="$name"
          )"

          if [ -z "$entry" ] || [ "$entry" = "$id" ]; then
            new_name="$id"
          else
            new_name="$prefix$entry"
          fi

          hyprctl dispatch renameworkspace "$id" "$new_name"
        '';

        shareKdeconnect = lib.getExe (
          pkgs.writeShellScriptBin "kdeconnect-share" ''
            type="$(wl-paste -l | head -1)"
            device="$(kdeconnect-cli -a --id-only | head -1)"

            if [ "$type" = "image/png" ]; then
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
      {
        bind = [
          # Workspace
          (mkBind "SUPER" "r" "${uwsm} ${renameWorkspace}")

          # Applications
          (mkBind "SUPER" "RETURN" (defaultApp "x-scheme-handler/terminal"))
          (mkBind "SUPER" "e" (defaultApp "text/plain"))
          (mkBind "SUPER" "b" (defaultApp "x-scheme-handler/https"))

          # Screenshots
          (mkBind "" "PRINT" "${grimblast} --notify --freeze copy area")
          (mkBind "SHIFT" "PRINT" "${grimblast} --notify --freeze copy output")

          # Audio and brightness
          (mkBind "" "XF86AudioRaiseVolume" "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+")
          (mkBind "" "XF86AudioLowerVolume" "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-")
          (mkBind "" "XF86AudioMute" "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle")
          (mkBind "" "XF86MonBrightnessUp" "${lib.getExe pkgs.brightnessctl} set 5%+")
          (mkBind "" "XF86MonBrightnessDown" "${lib.getExe pkgs.brightnessctl} set 5%-")

          # Noctalia launcher
          (mkBind "SUPER" "x" "noctalia msg panel-toggle launcher")
        ]
        ++ lib.optionals config.programs.wofi.enable (
          let
            wofi = lib.getExe config.programs.wofi.package;
          in
          [
            (mkBind "SUPER" "x" "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%")
            (mkBind "SUPER" "s" "specialisation $(specialisation | ${wofi} -S dmenu)")
            (mkBind "SUPER" "d" "${wofi} -S run")
          ]
        )
        ++ lib.optionals config.programs.tofi.enable (
          let
            tofi = lib.getExe pkgs.tofi;
          in
          [
            (mkBind "SUPER" "s" "specialisation $(specialisation | ${tofi})")
            (mkBind "SUPER" "d" "${tofi}-run")
          ]
        )
        ++ lib.optionals config.programs.password-store.enable (
          let
            passWofi = lib.getExe (
              pkgs.pass-wofi.override {
                pass = config.programs.password-store.package;
              }
            );
          in
          [
            (mkBind "" "XF86Calculator" passWofi)
            (mkBind "SHIFT" "XF86Calculator" "${passWofi} fill")

            (mkBind "SUPER" "semicolon" passWofi)
            (mkBind "SHIFT + SUPER" "semicolon" "${passWofi} fill")
            
          ]
        )
        ++ lib.optionals config.services.cliphist.enable [
          (mkBind "SUPER" "c" "noctalia msg panel-toggle clipboard")
        ]
        ++ lib.optionals config.services.kdeconnect.enable [
          (mkBind "SUPER" "v" shareKdeconnect)
        ];

        monitor = map (
          m:
          if m.enabled then
            {
              output = m.name;
              mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = m.position;
              scale = m.scale;
              bitdepth = m.bitdepth;
              transform = m.transform;
            }
          else
            {
              output = m.name;
              disabled = true;
            }
        ) config.monitors;

        workspace_rule = map (m: {
          workspace = toString m.workspace;
          monitor = m.name;
        }) (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
      }
    );
  };
}
