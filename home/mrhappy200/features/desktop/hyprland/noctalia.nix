{ pkgs, inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        pomodoro = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        unicode-picker = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
    settings = {
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWrapText = true;
        customLaunchPrefix = "uwsm app --";
        customLaunchPrefixEnabled = true;
        enableClipPreview = true;
        enableClipboardHistory = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        pinnedApps = [

        ];
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "foot-client";
        useApp2Unit = false;
        viewMode = "list";
      };
      audio = {
        cavaFrameRate = 30;
        mprisBlacklist = [

        ];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        density = "compact";
        exclusive = true;
        floating = false;
        marginHorizontal = 4;
        marginVertical = 4;
        monitors = [
          "DP-3"
        ];
        outerCorners = true;
        position = "top";
        showCapsule = true;
        showOutline = false;
        useSeparateOpacity = false;
        widgets = {
          center = [
            {
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              showApplications = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              colorizeSystemIcon = "none";
              enableColorization = false;
              hideMode = "expandWithOutput";
              icon = "heart";
              id = "CustomButton";
              leftClickExec = "";
              leftClickUpdateText = false;
              maxTextLength = {
                horizontal = 80;
                vertical = 10;
              };
              middleClickExec = "";
              middleClickUpdateText = false;
              parseJson = false;
              rightClickExec = "";
              rightClickUpdateText = false;
              showIcon = false;
              textCollapse = "";
              textCommand = "${pkgs.hppylrx}/bin/hppylrx";
              textIntervalMs = 5000;
              textStream = true;
              wheelDownExec = "";
              wheelDownUpdateText = false;
              wheelExec = "";
              wheelMode = "unified";
              wheelUpExec = "";
              wheelUpUpdateText = false;
              wheelUpdateText = false;
            }
          ];
          left = [
            {
              icon = "rocket";
              id = "Launcher";
              usePrimaryColor = false;
            }
            {
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
            }
            {
              compactMode = true;
              diskPath = "/persist/";
              id = "SystemMonitor";
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskUsage = false;
              showGpuTemp = true;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              useMonospaceFont = true;
              usePrimaryColor = false;
            }
            {
              colorizeIcons = true;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = false;
            }
            {
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "transparent";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 300;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = false;
              showProgressRing = true;
              showVisualizer = true;
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          right = [
            {
              capsLockIcon = "letter-c-small";
              id = "LockKeys";
              numLockIcon = "letter-n-small";
              scrollLockIcon = "letter-s-small";
              showCapsLock = true;
              showNumLock = true;
              showScrollLock = true;
            }
            {
              blacklist = [

              ];
              colorizeIcons = true;
              drawerEnabled = false;
              hidePassive = false;
              id = "Tray";
              pinned = [

              ];
            }
            {
              defaultSettings = {
                autoStartBreaks = false;
                autoStartWork = false;
                compactMode = false;
                longBreakDuration = 15;
                sessionsBeforeLongBreak = 4;
                shortBreakDuration = 5;
                workDuration = 25;
              };
              id = "plugin:pomodoro";
            }
            {
              hideWhenZero = false;
              id = "NotificationHistory";
              showUnreadBadge = true;
            }
            {
              displayMode = "onhover";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              displayMode = "onhover";
              id = "Brightness";
            }
            {
              id = "plugin:catwalk";
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              id = "ControlCenter";
              useDistroLogo = true;
            }

          ];
        };
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = false;
      };
      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
        ];
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "Bluetooth";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };
      desktopWidgets = {
        enabled = false;
      };
      dock = {
        enabled = false;
      };
      general = {
        allowPanelsOnScreenWithoutBar = true;
        animationDisabled = false;
        animationSpeed = 1;
        avatarImage = "/home/mrhappy200/.face";
        boxRadiusRatio = 1;
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableShadows = true;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        language = "en";
        lockOnSuspend = true;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
      };
      hooks = {
        darkModeChange = "";
        enabled = false;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        wallpaperChange = "";
      };
      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Naarden";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = true;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };
      network = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        wifiEnabled = false;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = false;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "2929";
      };
      notifications = {
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [

        ];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = true;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = false;
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };
      osd = {
        autoHideMs = 2000;
        enabled = true;
        enabledTypes = [
          0
          1
          2
          null
          3
        ];
        location = "top_right";
        monitors = [

        ];
        overlayLayer = true;
      };
      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "grid";
        largeButtonsStyle = false;
        position = "center";
        powerOptions = [
          {
            action = "lock";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "suspend";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "hibernate";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "reboot";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "logout";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "shutdown";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
        ];
        showHeader = true;
        showNumberLabels = true;
      };
      settingsVersion = 39;
      systemMonitor = {
        cpuCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskCriticalThreshold = 90;
        diskPollingInterval = 3000;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = true;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuPollingInterval = 3000;
        gpuWarningThreshold = 80;
        loadAvgPollingInterval = 3000;
        memCriticalThreshold = 90;
        memPollingInterval = 3000;
        memWarningThreshold = 80;
        networkPollingInterval = 3000;
        tempCriticalThreshold = 90;
        tempPollingInterval = 3000;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };
      templates = {
        alacritty = false;
        cava = false;
        code = false;
        discord = false;
        emacs = false;
        enableUserTemplates = false;
        foot = false;
        fuzzel = false;
        ghostty = false;
        gtk = false;
        helix = false;
        hyprland = false;
        kcolorscheme = false;
        kitty = false;
        mango = false;
        niri = false;
        pywalfox = false;
        qt = false;
        spicetify = false;
        telegram = false;
        vicinae = false;
        walker = false;
        wezterm = false;
        yazi = false;
        zed = false;
        zenBrowser = false;
      };
      ui = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
        fontDefault = "DejaVu Sans";
        fontDefaultScale = 1;
        fontFixed = "DejaVu Sans Mono";
        fontFixedScale = 1;
        networkPanelView = "wifi";
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        tooltipsEnabled = true;
        wifiDetailsViewMode = "grid";
      };
      wallpaper = {
        enabled = false;
      };
    };
  };
}
