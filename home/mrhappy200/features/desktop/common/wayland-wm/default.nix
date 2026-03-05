{ pkgs, ... }:
{
  imports = [
    #./alacritty.nix
    ./foot.nix
    ./cliphist.nix
    ./gammastep.nix
    #    ./mako.nix
    #    ./qutebrowser.nix
    #./waybar.nix
    #./wofi.nix
    ./tofi.nix
    ./zathura.nix
    ./imv.nix
    ./waypipe.nix
    # ./swayosd.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    pwvucontrol
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  xdg = {
    portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
      ];

      config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
  };
  xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
    enable = true;
    text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD='footclient -a "termfilechooser" -T "terminal filechooser"'
      open_mode=suggested
      save_mode=last
    '';
  };
}
