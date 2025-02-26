{...}: let
in {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "footclient.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "footclient.desktop";
    };
  };
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
    };
  };
}
