{ lib, config, ... }:
{
  # Set as default terminal
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
      main = {
        term = "xterm-256color";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors-dark = {
        alpha = lib.mkForce 0.45;
        blur = true;
      };
      colors-light = {
        alpha = lib.mkForce 0.45;
        blur = true;
      };
    };
  };
}
