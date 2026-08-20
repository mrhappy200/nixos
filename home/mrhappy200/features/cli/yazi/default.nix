{ inputs, pkgs, ... }:
let
  yazi = inputs.yazi;

  gvfsWithBackends = pkgs.gvfs.override {
    samba = pkgs.samba;
    libmtp = pkgs.libmtp;
    libgphoto2 = pkgs.libgphoto2;
    avahi = pkgs.avahi;
    gcr_4 = pkgs.gcr_4;
    libsecret = pkgs.libsecret;
    gnome-online-accounts = pkgs.gnome-online-accounts;
  };

  #f3d-preview = inputs.f3d-preview-yazi;
  f3d-preview = pkgs.runCommand "f3d-preview-patched" { } ''
    cp -r ${inputs.f3d-preview-yazi} $out
    chmod -R +w $out
    sed -i '/ya\.preview_widgets/d' $out/main.lua
  '';
in
{
  home.packages = with pkgs; [
    wl-clipboard
    jdupes
    mediainfo
    udisks2
    util-linux
    # ── GVFS + backends ────────────────────────────────────────────────────
    gvfsWithBackends
    samba # smb://
    libmtp # mtp://
    libgphoto2 # gphoto2:// (cameras/PTP)
    sshfs # sftp://
    ## Causes build failure
    #curlftpfs # ftp://
    nfs-utils # nfs://
    fuse3 # FUSE layer for sshfs, curlftpfs, gvfsd-fuse
    avahi # mDNS discovery for LAN shares
    dbus # gvfs daemon IPC
    gnome-online-accounts
    dragon-drop
    libsecret
    f3d
    gcr_4
    glib # provides the `gio` CLI binary
  ];

  programs.yazi = {
    enable = true;
    package = (
      yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        _7zz = pkgs._7zz-rar;
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
          {
            url = "*.{3mf,obj,pts,ply,stl,step,stp}";
            run = "f3d-preview";
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
          {
            url = "*.{3mf,obj,pts,ply,stl,step,stp}";
            run = "f3d-preview";
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
      inherit gvfs;
      inherit f3d-preview;
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
          on = [
            "M"
            "m"
          ];
          run = "plugin gvfs -- select-then-mount --jump";
          desc = "Select device to mount and jump to its mount point";
        }
        {
          on = "Y";
          run = "shell 'dragon-drop --and-exit -- $@' --orphan";
          desc = "Drag and drop selected files";
        }
        {
          on = [
            "M"
            "R"
          ];
          run = "plugin gvfs -- remount-current-cwd-device";
          desc = "Remount device under cwd";
        }
        {
          on = [
            "M"
            "u"
          ];
          run = "plugin gvfs -- select-then-unmount --eject";
          desc = "Select device then eject";
        }
        {
          on = [
            "M"
            "U"
          ];
          run = "plugin gvfs -- select-then-unmount --eject --force";
          desc = "Select device then force eject/unmount";
        }
        {
          on = [
            "M"
            "a"
          ];
          run = "plugin gvfs -- add-mount";
          desc = "Add a GVFS mount URI";
        }
        {
          on = [
            "M"
            "e"
          ];
          run = "plugin gvfs -- edit-mount";
          desc = "Edit a GVFS mount URI";
        }
        {
          on = [
            "M"
            "r"
          ];
          run = "plugin gvfs -- remove-mount";
          desc = "Remove a GVFS mount URI";
        }
        {
          on = [
            "g"
            "m"
          ];
          run = "plugin gvfs -- jump-to-device --automount";
          desc = "Automount then select device to jump to its mount point";
        }
        {
          on = [
            "`"
            "`"
          ];
          run = "plugin gvfs -- jump-back-prev-cwd";
          desc = "Jump back to the position before jumped to device";
        }
        {
          on = [
            "M"
            "t"
          ];
          run = "plugin gvfs -- automount-when-cd";
          desc = "Enable automount when cd to device under cwd";
        }
        {
          on = [
            "M"
            "T"
          ];
          run = "plugin gvfs -- automount-when-cd --disabled";
          desc = "Disable automount when cd to device under cwd";
        }
      ];
    };
  };
}
#{ inputs, pkgs, ... }:
#let
#  yazi = inputs.yazi;
#in
#
#{
#  home.packages = with pkgs; [
#    wl-clipboard
#    jdupes
#    mediainfo
#    udisks2
#    util-linux
#  ];
#  programs.yazi = {
#    enable = true;
#    package = (
#      yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
#        _7zz = pkgs._7zz-rar; # Support for RAR extraction
#      }
#    );
#    enableFishIntegration = true;
#    shellWrapperName = "y";
#
#    settings = {
#      mgr = {
#        show_hidden = false;
#      };
#      preview = {
#        max_width = 1000;
#        max_height = 1000;
#      };
#      plugin = {
#        prepend_preloaders = [
#          {
#            mime = "{audio,video,image}/*";
#            run = "mediainfo";
#          }
#          {
#            mime = "application/subrip";
#            run = "mediainfo";
#          }
#          {
#            mime = "application/postscript";
#            run = "mediainfo";
#          }
#        ];
#        prepend_previewers = [
#          {
#            mime = "{audio,video,image}/*";
#            run = "mediainfo";
#          }
#          {
#            mime = "application/subrip";
#            run = "mediainfo";
#          }
#          {
#            mime = "application/postscript";
#            run = "mediainfo";
#          }
#        ];
#      };
#    };
#
#    plugins = with pkgs.yaziPlugins; {
#      inherit chmod;
#      inherit full-border;
#      inherit toggle-pane;
#      inherit wl-clipboard;
#      inherit git;
#      inherit dupes;
#      inherit mount;
#      inherit mediainfo;
#    };
#
#    initLua = ./init.lua;
#    keymap = {
#      mgr.prepend_keymap = [
#        {
#          on = "<C-y>";
#          run = "plugin wl-clipboard";
#          desc = "Yank to system clipboard";
#        }
#        {
#          on = "T";
#          run = "plugin toggle-pane max-preview";
#          desc = "Maximize or restore the preview pane";
#        }
#        {
#          on = [
#            "c"
#            "m"
#          ];
#          run = "plugin chmod";
#          desc = "Chmod on selected files";
#        }
#        {
#          on = [
#            "<C-J>"
#            "i"
#          ];
#          run = "plugin dupes interactive";
#          desc = "Run dupes interactive";
#        }
#        {
#          on = [
#            "<C-J>"
#            "o"
#          ];
#          run = "plugin dupes override";
#          desc = "Run dupes override";
#        }
#        {
#          on = [
#            "<C-J>"
#            "d"
#          ];
#          run = "plugin dupes dry";
#          desc = "Run dupes dry";
#        }
#        {
#          on = [
#            "<C-J>"
#            "a"
#          ];
#          run = "plugin dupes apply";
#          desc = "Run dupes apply";
#        }
#        {
#          on = [ "M" ];
#          run = "plugin mount";
#          desc = "Open mount plugin";
#        }
#
#      ];
#    };
#  };
#}
