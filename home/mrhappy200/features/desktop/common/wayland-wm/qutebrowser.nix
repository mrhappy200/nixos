{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.colorscheme) colors;
in
{
  home.persistence = {
    "/persist/".directories = [
      ".config/qutebrowser/bookmarks"
      ".config/qutebrowser/greasemonkey"
      ".local/share/qutebrowser"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "text/xml" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
  };

  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    searchEngines = rec {
      #kagi = "https://kagi.com/search?q={}";
      duckduckgo = "https://duckduckgo.com/?q={}";
      google = "https://google.com/search?hl=en&q={}";
      #k = kagi;
      ddg = duckduckgo;
      g = google;
      DEFAULT = google;
    };
    settings = {
      url = rec {
        #default_page = "https://kagi.com";
        default_page = "https://google.com";
        start_pages = [ default_page ];
      };
      downloads.open_dispatcher = "${lib.getExe pkgs.handlr-regex} open {}";
      editor.command = [
        "${lib.getExe pkgs.handlr-regex}"
        "open"
        "{file}"
      ];
      tabs = {
        show = "switching";
        position = "left";
        indicator.width = 0;
      };
      # Also avoids qutebrowser stealing focus when reloading
      new_instance_open_target = "window";
    };
    extraConfig = ''
      c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
    '';
  };
}
