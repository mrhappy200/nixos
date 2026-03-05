{ inputs, pkgs, ... }:
let
  yazi = inputs.yazi;
in

{
  home.packages = with pkgs; [
    wl-clipboard
    jdupes
    mediainfo
    udisks2
    util-linux
  ];
  programs.yazi = {
    enable = true;
    package = (
      yazi.packages.${pkgs.system}.default.override {
        _7zz = pkgs._7zz-rar; # Support for RAR extraction
      }
    );
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = false;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      plugin = {
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
        prepend_previewers = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit chmod;
      inherit full-border;
      inherit toggle-pane;
      inherit wl-clipboard;
      inherit git;
      inherit dupes;
      inherit mount;
      inherit mediainfo;
    };

    initLua = ./init.lua;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-y>";
          run = "plugin wl-clipboard";
          desc = "Yank to system clipboard";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [
            "<C-J>"
            "i"
          ];
          run = "plugin dupes interactive";
          desc = "Run dupes interactive";
        }
        {
          on = [
            "<C-J>"
            "o"
          ];
          run = "plugin dupes override";
          desc = "Run dupes override";
        }
        {
          on = [
            "<C-J>"
            "d"
          ];
          run = "plugin dupes dry";
          desc = "Run dupes dry";
        }
        {
          on = [
            "<C-J>"
            "a"
          ];
          run = "plugin dupes apply";
          desc = "Run dupes apply";
        }
        {
          on = [ "M" ];
          run = "plugin mount";
          desc = "Open mount plugin";
        }

      ];
    };
  };
}
