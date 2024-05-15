{config, ...}: let
in {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
    };
    settings = {
      shell_integration = "no-rc"; # I prefer to do it manually
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 15;
    };
  };
}
