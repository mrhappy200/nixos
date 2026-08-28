{ pkgs, ... }:
let
  kandoConfig = {
    version = "2.3.1";
    locale = "auto";
    showIntroductionDialog = true;
    menuTheme = "default";
    darkMenuTheme = "default";
    menuThemeColors = {
    };
    darkMenuThemeColors = {
    };
    enableDarkModeForMenuThemes = false;
    enableSelectionWedges = false;
    soundTheme = "none";
    soundVolume = 0.5;
    enableVersionCheck = true;
    ignoreWriteProtectedConfigFiles = false;
    settingsWindowColorScheme = "system";
    settingsWindowFlavor = "auto";
    trayIconFlavor = "color";
    hardwareAcceleration = true;
    lazyInitialization = false;
    zoomFactor = 1;
    hideSettingsButton = false;
    settingsButtonPosition = "bottom-right";
    windowsInkWorkaround = true;
    maxSelectionRadius = 0;
    centerDeadZone = 50;
    minParentDistance = 150;
    dragThreshold = 15;
    fadeInDuration = 150;
    fadeOutDuration = 200;
    keepInputFocus = false;
    enableMarkingMode = true;
    enableTurboMode = true;
    warpMouse = true;
    hoverModeNeedsConfirmation = false;
    gestureMinStrokeLength = 150;
    gestureMinStrokeAngle = 20;
    gestureJitterThreshold = 10;
    gesturePauseTimeout = 100;
    fixedStrokeLength = 0;
    rmbSelectsParent = false;
    enableGamepad = true;
    gamepadBackButton = 1;
    gamepadCloseButton = 2;
    sameShortcutBehavior = "nothing";
    wlrootsPointerGetTimeoutMouse = 500;
    wlrootsPointerGetTimeoutTouch = 1500;
    wlrootsPointerGetTimeoutDefaultBehavior = "center";
    useDefaultOsShowSettingsHotkey = true;
    enableAchievements = true;
    enableAchievementNotifications = true;
  };
  kandoMenus = {
    version = "2.3.1";
    menus = [
      {
        shortcut = "Control+Space";
        shortcutID = "example-menu";
        centered = false;
        root = {
          type = "submenu";
          name = "Example Menu";
          icon = "award_star";
          iconTheme = "material-symbols-rounded";
          children = [
            {
              type = "submenu";
              name = "Apps";
              icon = "apps";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "A";
              children = [
                {
                  type = "command";
                  data = {
                    command = "x-www-browser";
                  };
                  name = "Web Browser";
                  icon = "globe";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "W";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-email";
                  };
                  name = "E-Mail";
                  icon = "mail";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "E";
                }
                {
                  type = "command";
                  data = {
                    command = "gimp";
                  };
                  name = "GIMP";
                  icon = "gimp";
                  iconTheme = "simple-icons";
                  quickSelectKey = "G";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open ~";
                  };
                  name = "File Browser";
                  icon = "folder_shared";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "F";
                }
                {
                  type = "command";
                  data = {
                    command = "x-terminal-emulator";
                  };
                  name = "Terminal";
                  icon = "terminal";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "T";
                }
              ];
            }
            {
              type = "submenu";
              name = "Web Links";
              icon = "public";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "L";
              children = [
                {
                  type = "uri";
                  data = {
                    uri = "https://www.google.com";
                  };
                  name = "Google";
                  icon = "google";
                  iconTheme = "simple-icons";
                  quickSelectKey = "G";
                }
                {
                  type = "uri";
                  data = {
                    uri = "https://github.com/kando-menu/kando";
                  };
                  name = "Kando on GitHub";
                  icon = "github";
                  iconTheme = "simple-icons";
                  quickSelectKey = "H";
                }
                {
                  type = "uri";
                  data = {
                    uri = "https://ko-fi.com/schneegans";
                  };
                  name = "Kando on Ko-fi";
                  icon = "kofi";
                  iconTheme = "simple-icons";
                  quickSelectKey = "K";
                }
                {
                  type = "uri";
                  data = {
                    uri = "https://www.youtube.com/@simonschneegans";
                  };
                  name = "Kando on YouTube";
                  icon = "youtube";
                  iconTheme = "simple-icons";
                  quickSelectKey = "Y";
                }
                {
                  type = "uri";
                  data = {
                    uri = "https://discord.gg/hZwbVSDkhy";
                  };
                  name = "Kando on Discord";
                  icon = "discord";
                  iconTheme = "simple-icons";
                  quickSelectKey = "D";
                }
              ];
            }
            {
              type = "hotkey";
              data = {
                hotkey = "ControlLeft+AltLeft+ArrowRight";
                delayed = false;
              };
              name = "Next Workspace";
              icon = "arrow_forward";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "N";
            }
            {
              type = "submenu";
              name = "Clipboard";
              icon = "assignment";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "C";
              children = [
                {
                  type = "hotkey";
                  data = {
                    hotkey = "ControlLeft+KeyV";
                    delayed = true;
                  };
                  name = "Paste";
                  icon = "content_paste_go";
                  iconTheme = "material-symbols-rounded";
                  angle = 90;
                  quickSelectKey = "V";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "ControlLeft+KeyC";
                    delayed = true;
                  };
                  name = "Copy";
                  icon = "content_copy";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "C";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "ControlLeft+KeyX";
                    delayed = true;
                  };
                  name = "Cut";
                  icon = "cut";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "X";
                }
              ];
            }
            {
              type = "submenu";
              name = "Audio";
              icon = "play_circle";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "A";
              children = [
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MediaTrackNext";
                    delayed = false;
                  };
                  name = "Next Track";
                  icon = "skip_next";
                  iconTheme = "material-symbols-rounded";
                  angle = 90;
                  quickSelectKey = "N";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MediaPlayPause";
                    delayed = false;
                  };
                  name = "Play / Pause";
                  icon = "play_pause";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "P";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "AudioVolumeMute";
                    delayed = false;
                  };
                  name = "Mute";
                  icon = "music_off";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "M";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MediaTrackPrevious";
                    delayed = false;
                  };
                  name = "Previous Track";
                  icon = "skip_previous";
                  iconTheme = "material-symbols-rounded";
                  angle = 270;
                  quickSelectKey = "P";
                }
              ];
            }
            {
              type = "submenu";
              name = "Windows";
              icon = "select_window";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "W";
              children = [
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MetaLeft+ArrowUp";
                    delayed = true;
                  };
                  name = "Toggle Maximize";
                  icon = "open_in_full";
                  iconTheme = "material-symbols-rounded";
                  angle = 0;
                  quickSelectKey = "F";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MetaLeft+ArrowRight";
                    delayed = true;
                  };
                  name = "Tile Right";
                  icon = "text_select_jump_to_end";
                  iconTheme = "material-symbols-rounded";
                  angle = 90;
                  quickSelectKey = "R";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "AltLeft+F4";
                    delayed = true;
                  };
                  name = "Close Window";
                  icon = "cancel_presentation";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "X";
                }
                {
                  type = "hotkey";
                  data = {
                    hotkey = "MetaLeft+ArrowLeft";
                    delayed = true;
                  };
                  name = "Tile Left";
                  icon = "text_select_jump_to_beginning";
                  iconTheme = "material-symbols-rounded";
                  angle = 270;
                  quickSelectKey = "L";
                }
              ];
            }
            {
              type = "hotkey";
              data = {
                hotkey = "ControlLeft+AltLeft+ArrowLeft";
                delayed = false;
              };
              name = "Previous Workspace";
              icon = "arrow_back";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "P";
            }
            {
              type = "submenu";
              name = "Bookmarks";
              icon = "folder_special";
              iconTheme = "material-symbols-rounded";
              quickSelectKey = "B";
              children = [
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir DOWNLOAD)\"";
                  };
                  name = "Downloads";
                  icon = "download";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "D";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir VIDEOS)\"";
                  };
                  name = "Videos";
                  icon = "video_camera_front";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "V";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir PICTURES)\"";
                  };
                  name = "Pictures";
                  icon = "imagesmode";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "P";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir DOCUMENTS)\"";
                  };
                  name = "Documents";
                  icon = "text_ad";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "O";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir DESKTOP)\"";
                  };
                  name = "Desktop";
                  icon = "desktop_windows";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "E";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open ~";
                  };
                  name = "Home";
                  icon = "home";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "H";
                }
                {
                  type = "command";
                  data = {
                    command = "xdg-open \"$(xdg-user-dir MUSIC)\"";
                  };
                  name = "Music";
                  icon = "music_note";
                  iconTheme = "material-symbols-rounded";
                  quickSelectKey = "M";
                }
              ];
            }
          ];
        };
      }
    ];
    collections = [
      {
        name = "Favorites";
        icon = "favorite";
        iconTheme = "material-symbols-rounded";
        tags = [
          "favs"
        ];
      }
    ];
  };

  # Custom package wrapper ensuring correct desktop entry name for D-Bus / XDG portal app ID matching
  kandoFixed = pkgs.kando.overrideAttrs (old: {
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "menu.kando.Kando";
        exec = "kando %U";
        icon = "kando";
        desktopName = "Kando";
        genericName = "Pie Menu";
        comment = "The Cross-Platform Pie Menu";
        categories = [ "Utility" ];
        mimeTypes = [ "x-scheme-handler/kando" ];
      })
    ];
  });
in
{
  home.packages = [ kandoFixed ];
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      {
        name = "kando";
        "match:class" = "menu.kando.Kando";
        "match:title" = "Kando Menu";
        no_blur = "on";
        opaque = "on";
        move = "0 0";
        rounding = "0";
        size = "100% 100%";
        border_size = "0";
        no_anim = "on";
        float = "on";
        pin = "on";
      }
    ];
    bind = [
      "SUPERALT, XF86AudioMicMute, global, menu.kando.Kando:pen-menu"
    ];
  };

  xdg.configFile."kando/config.json".text = builtins.toJSON kandoConfig;
  xdg.configFile."kando/menus.json".text = builtins.toJSON kandoMenus;
}
