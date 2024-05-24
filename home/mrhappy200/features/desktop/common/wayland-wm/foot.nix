{...}: let
in {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "org.codeberg.dnkl.footclient.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "org.codeberg.dnkl.footclient.desktop";
    };
  };
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
    };
  };
}
