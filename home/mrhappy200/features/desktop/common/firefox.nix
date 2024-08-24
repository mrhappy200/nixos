{lib, inputs, config, pkgs, ...}: {
  programs.browserpass.enable = true;


  stylix.targets.firefox.enable = true;

  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    profiles.mrhappy200 = {
      bookmarks = {};
      extensions = with pkgs.inputs.firefox-addons; [
        ublock-origin
        sponsorblock
	#userchrome-toggle-extended
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
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
	"privacy.sanitize.sanitizeOnShutdown" = true;
        "signon.rememberSignons" = false;
      };
    };
  };

  home = {
    persistence = {
      # Not persisting is safer
      #"/nix/persist/home/mrhappy200".directories = [ ".mozilla/firefox" ];
      #"/nix/persist/home/mrhappy200/".directories = [ { directory = ".mozilla/firefox/mrhappy200/storage/default/";}];
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
