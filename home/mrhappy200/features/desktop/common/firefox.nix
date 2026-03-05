{
  pkgs,
  nixosConfig,
  config,
  lib,
  ...
}:
let
  mkColor = color: {
    r = config.lib.stylix.colors."${color}-rgb-r";
    g = config.lib.stylix.colors."${color}-rgb-g";
    b = config.lib.stylix.colors."${color}-rgb-b";
  };
in
{
  programs.browserpass.enable = true;
  stylix.targets.firefox = {
    profileNames = [ "mrhappy200" ];
    enable = true;
    colorTheme.enable = true;
  };
  stylix.enable = true;
  programs.firefox = {
    enable = true;
    profiles.mrhappy200 = {
      extensions = {
        force = true;
        packages = with pkgs.inputs.firefox-addons; [
          ublock-origin
          sponsorblock
          firefox-color
        ];
        settings."FirefoxColor@mozilla.com".settings = {
          firstRunDone = true;
          theme = {
            images.additional_backgrounds = lib.mkForce [ "${nixosConfig.custom-stylix.svgWallpaper}" ];
            colors = {
              toolbar_field = lib.mkForce (mkColor "base01");
            };
          };
        };
      };
      search = {
        force = true;
        default = "google";
        privateDefault = "ddg";
        order = [
          "kagi"
          "ddg"
          "google"
        ];
        engines = {
          kagi = {
            name = "Kagi";
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/favicon.ico";
          };
          bing.metaData.hidden = true;
        };
      };
      bookmarks = { };
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;

        "browser.startup.homepage" = "about:home";

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.blocked" = lib.genAttrs [
          # Youtube
          "26UbzFJ7qT9/4DhodHKA1Q=="
          # Facebook
          "4gPpjkxgZzXPVtuEoAL9Ig=="
          # Wikipedia
          "eV8/WsSLxHadrTL1gAxhug=="
          # Reddit
          "gLv0ja2RYVgxKdp0I5qwvA=="
          # Amazon
          "K00ILysCaEq8+bEqV/3nuw=="
          # Twitter
          "T9nJot5PurhJSy8n038xGA=="
        ] (_: 1);

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        # Remove close button
        "browser.tabs.inTitlebar" = 0;
        # Compact UI (might break stuff)
        "browser.uidensity" = 1;
        # Vertical tabs
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
        "sidebar.animation.duration-ms" = 100;
        "sidebar.visibility" = "hide-sidebar";
        "sidebar.main.tools" = "history,bookmarks";
        # Layout
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            unified-extensions-area = [
              "sponsorblocker_ajay_app-browser-action"
              "firefoxcolor_mozilla_com-browser-action"
            ];
            widget-overflow-fixed-list = [ ];
            nav-bar = [
              "back-button"
              "forward-button"
              "vertical-spacer"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "ublock0_raymondhill_net-browser-action"
              "_testpilot-containers-browser-action"
              "reset-pbm-toolbar-button"
              "unified-extensions-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            TabsToolbar = [ ];
            vertical-tabs = [ "tabbrowser-tabs" ];
            PersonalToolbar = [ "personal-bookmarks" ];
          };
          seen = [
            "save-to-pocket-button"
            "developer-button"
            "ublock0_raymondhill_net-browser-action"
            "sponsorblocker_ajay_app-browser-action"
            "firefoxcolor_mozilla_com-browser-action"
            "_testpilot-containers-browser-action"
            "screenshot-button"
          ];
          dirtyAreaCache = [
            "nav-bar"
            "PersonalToolbar"
            "toolbar-menubar"
            "TabsToolbar"
            "widget-overflow-fixed-list"
            "vertical-tabs"
          ];
          currentVersion = 23;
          newElementCount = 10;
        };
      };
      userChrome = ''
        /* The main window background */
        #main-window {
        	-moz-appearance: /*-moz-mac-vibrancy-dark*/ none !important; /* -moz-win-glass */
        	background-color: rgba(25, 25, 25, .8) !important;
        	background-image: none !important;
        	/*background: url(background.jpg);*/
        }

        #navigator-toolbox {
        	background-color: rgba(0, 0, 0, .8);
        }

        /* Transparent Stuff */
         #TabsToolbar, #titlebar, #navigator-toolbox, box, .theme-body {
        	-moz-appearance: none !important;
        	background-color: rgba(0, 0, 0, 0) !important;
        	background-image: none !important;
        	border: none;
        	outline: none;
        }

        /* Light Transparent Stuff */
        .tab-content, #tabs-newtab-button {
        	-moz-appearance: none !important;
        	color: #eee !important;
        	background-image: none !important;
        	fill: #eee !important;
        }

        .tab-content[selected="true"]{
        	color: var(--lwt-tab-text) !important;
        }

        /* Nuke all borders and outlines, they look bad */
        * {
        	border: none !important;
        	outline: none !important;
        	box-shadow: none !important;
        }
      '';
    };
  };

  home = {
    persistence = {
      # Not persisting is safer
      # "/persist".directories = [ ".mozilla/firefox" ];
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
