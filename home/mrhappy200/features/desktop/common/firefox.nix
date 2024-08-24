{lib, inputs, config, pkgs, ...}: {
  programs.browserpass.enable = true;


  #stylix.targets.firefox.enable = false;

  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    profiles.mrhappy200 = {
      bookmarks = {};
      extensions = with pkgs.inputs.firefox-addons; [
        ublock-origin
        sponsorblock
	userchrome-toggle-extended
        dearrow
        browserpass
	#sidebery
	darkreader
	#adaptive-tab-bar-colour
      ];
      bookmarks = {};
      settings = {
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "extensions.autoDisableScopes" = 0;
        "browser.download.useDownloadDir" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage" = "https://search.nixos.org";
        # "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
				#"browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_3c078156-979c-498b-8990-85f7987dd929_-browser-action","sponsorblocker_ajay_app-browser-action","dearrow_ajay_app-browser-action","userchrome-toggle_joolee_nl-browser-action","browserpass_maximbaz_com-browser-action","atbc_easonwong-browser-action"],"nav-bar":["back-button","stop-reload-button","forward-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","zoom-controls","fxa-toolbar-menu-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["sidebar-button","downloads-button","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","customizableui-special-spring6","fullscreen-button","screenshot-button","history-panelmenu","bookmarks-menu-button","firefox-view-button","preferences-button","tabbrowser-tabs","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","browserpass_maximbaz_com-browser-action","userchrome-toggle_joolee_nl-browser-action","addon_darkreader_org-browser-action","atbc_easonwong-browser-action","dearrow_ajay_app-browser-action","sponsorblocker_ajay_app-browser-action","ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","developer-button"],"dirtyAreaCache":["unified-extensions-area","nav-bar","PersonalToolbar","TabsToolbar"],"currentVersion":20,"newElementCount":7}'';
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
	"privacy.sanitize.sanitizeOnShutdown" = true;
        "signon.rememberSignons" = false;
      };
            extraConfig = ''
      // userchrome.css usercontent.css activate
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Fill SVG Color
user_pref("svg.context-properties.content.enabled", true);

// CSS's `:has()` selector 
user_pref("layout.css.has-selector.enabled", true);

// Integrated calculator at urlbar
user_pref("browser.urlbar.suggest.calculator", true);

// Integrated unit convertor at urlbar
user_pref("browser.urlbar.unitConversion.enabled", true);

// Trim  URL
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.trimURLs", true);

// GTK rounded corners
user_pref("widget.gtk.rounded-bottom-corners.enabled", true);

// Who is bogus? (fixes Sidebery tab dragging on Linux)
user_pref("widget.gtk.ignore-bogus-leave-notify", 1);
'';
    };
  };

  home = {
    persistence = {
      # Not persisting is safer
      #"/nix/persist/home/mrhappy200".directories = [ ".mozilla/firefox" ];
      #"/nix/persist/home/mrhappy200/".directories = [ { directory = ".mozilla/firefox/mrhappy200/storage/default/";}];
    };
  };


  home.file.".mozilla/firefox/${config.programs.firefox.profiles.mrhappy200.path}/chrome".source = "${inputs.ShyFox}/chrome";

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
