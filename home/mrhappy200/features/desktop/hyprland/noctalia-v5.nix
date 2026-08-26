{
  config,
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
let
  rawIndex = builtins.readFile osConfig.custom-stylix.randomColourPath;
  cleanIndex = lib.strings.trim rawIndex;
  colourKey = "base0${cleanIndex}";
  COLOUR = osConfig.lib.stylix.colors.${colourKey};
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  home.packages = [
    pkgs.hyprshot
    pkgs.gpu-screen-recorder
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      audio = {
        enable_overdrive = true;
        enable_sounds = true;
        notification_sound = "/home/mrhappy200/Documents/minecraft-achievement.wav";
      };
      bar = {
        default = {
          capsule = true;
          center = [ "workspaces" ];
          end = [
            "tray"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "iio-lock"
            "brightness"
            "battery"
            "notifications"
            "control-center"
          ];
          margin_ends = 0;
          start = [
            "clock"
            "media"
            "audio_visualizer"
          ];
        };
      };
      battery = {
        warning_threshold = 0;
        device = {
          "/org/freedesktop/UPower/devices/battery_hid_0018o056Ao530Ax0002_battery_20" = {
            warning_threshold = 0;
          };
          "/org/freedesktop/UPower/devices/headset_dev_A8_E6_E8_2A_E5_9C" = {
            warning_threshold = 0;
          };
        };
      };
      control_center = {
        sidebar = "full";
        shortcuts = [
          {
            type = "wifi";
          }
          {
            type = "bluetooth";
          }
          {
            type = "caffeine";
          }
          {
            type = "power_profile";
          }
          {
            type = "system";
          }
        ];
      };
      desktop_widgets = {
        enabled = false;
      };
      dock = {
        background_opacity = 1.0;
      };
      hot_corners = {
        enabled = true;
        top_left = {
          action = "window_switcher";
        };
        top_right = {
          action = "control_center";
        };
      };
      location = {
        auto_locate = true;
      };
      lockscreen = {
        allow_empty_password = true;
        wallpaper = "${config.stylix.image}";
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
          "lockscreen-widget-0000000000000004"
          "lockscreen-widget-0000000000000005"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 82.0;
            box_width = 810.0;
            cx = 960.0;
            cy = 1023.0;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.0;
              background_radius = 0.0;
              center_password_text = true;
              input_opacity = 0.88;
              input_radius = 32.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = false;
              show_media = false;
              show_session_buttons = false;
              show_unlock_hint = true;
              show_weather = false;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 144.0;
            box_width = 480.0;
            cx = 479.328125;
            cy = 173.90625;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              clock_style = "digital";
              color = "${COLOUR}";
              format = "{:%H:%M:%S}";
            };
          };
          lockscreen-widget-0000000000000002 = {
            box_height = 480.0;
            box_width = 1200.0;
            cx = 1320.0;
            cy = 240.0;
            flip_y = true;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              background = false;
              bands = 32;
              centered = false;
              color_1 = "on_surface";
              color_2 = "on_surface";
              reversed = false;
              show_when_idle = false;
            };
          };
          lockscreen-widget-0000000000000003 = {
            box_height = 576.0;
            box_width = 384.0;
            cx = 256.0;
            cy = 568.0;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "media_player";
            settings = {
              background = false;
              background_color = "surface_variant";
              hide_when_no_media = false;
              layout = "vertical";
            };
          };
          lockscreen-widget-0000000000000004 = {
            box_height = 384.0;
            box_width = 640.0;
            cx = 1536.0;
            cy = 728.0;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "calendar";
            settings = {
              show_week_numbers = true;
            };
          };
          lockscreen-widget-0000000000000005 = {
            box_height = 224.0;
            box_width = 448.0;
            cx = 1632.0;
            cy = 1063.0;
            output = "eDP-1";
            placement_height = 1200.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "weather";
            settings = {
              show_forecast = true;
            };
          };
        };
      };
      nightlight = {
        enabled = true;
      };
      notification = {
        background_opacity = 1.0;
        layer = "overlay";
      };
      osd = {
        background_opacity = 1.0;
        kinds = {
          media = false;
        };
      };
      plugin_settings = {
        "nikolaj-zwergius/iio_lock" = {
          panel_open_near_click = true;
          panel_placement = "attached";
        };
      };
      plugins = {
        enabled = [ "nikolaj-zwergius/iio_lock" ];
      };
      shell = {
        external_ip_enabled = true;
        font_family = "DejaVu Sans";
        launch_apps_custom_command = "${pkgs.uwsm}/bin/uwsm-app -s a -t service --";
        password_style = "random";
        polkit_agent = true;
        screen_time_enabled = true;
        settings_window_translucent = true;
        telemetry_enabled = true;
        launcher = {
          categories = false;
          show_app_actions = true;
        };
        panel = {
          clipboard_placement = "attached";
          launcher_placement = "attached";
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_launcher = true;
          open_near_click_session = true;
          open_near_click_wallpaper = true;
          polkit_placement = "attached";
        };
        session = {
          grid = true;
          actions = [
            {
              action = "lock";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "1";
              variant = "default";
            }
            {
              action = "logout";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "2";
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "3";
              variant = "default";
            }
            {
              action = "command";
              command = "systemctl hibernate";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "hibernate";
              label = "Hibernate";
              variant = "default";
            }
            {
              action = "reboot";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "5";
              variant = "destructive";
            }
          ];
        };
      };
      theme = {
        builtin = "Noctalia";
        community_palette = "Oxocarbon";
        custom_palette = "stylix";
        source = "custom";
        wallpaper_scheme = "m3-content";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      wallpaper = {
        enabled = false;
      };
      widget = {
        audio_visualizer = {
          bands = 32;
          color_1 = "on_surface";
          color_2 = "on_surface";
          width = 128;
        };
        brightness = {
          show_label = false;
        };
        clock = {
          format = "{:%H:%M:%S}";
        };
        iio-lock = {
          type = "nikolaj-zwergius/iio_lock:iio-lock";
        };
        media = {
          max_length = 300;
          title_scroll = "on_hover";
        };
        notifications = {
          hide_when_no_unread = true;
        };
        sysmon = {
          show_glyph = false;
        };
        tray = {
          drawer = true;
          match_adjacent_spacing = true;
        };
        volume = {
          show_label = false;
        };
        workspaces = {
          hide_when_empty = true;
        };
      };
    };
  };
}
