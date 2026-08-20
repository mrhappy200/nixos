{
  pkgs,
  config,
  inputs,
  ...
}:
let
in
{
  imports = [
    ./global
    #./features/desktop/hyprland-illogical-impulse-dots
    ./features/desktop/hyprland
    ./features/nvim
    ./features/emacs
    ./features/desktop/common/3dprinter.nix
    ./features/desktop/common/flatpak.nix
    ./features/desktop/wireless
    ./features/desktop/vnc.nix
    ./features/desktop/common/blender.nix
    #./features/cli/mpd.nix
    ./features/cli/ollama.nix
    ./features/desktop/common/lanmouse.nix
    ./features/productivity
    ./features/pass
    ./features/games
    #./features/games/vr.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  # Red
  #wallpaper = pkgs.inputs.themes.wallpapers.cubist-crystal-brown-teal;

  home.packages = with pkgs; [
    #blender-hip
    kitty
    hyperhdr
    anki
    thonny
    # emacs
    graphviz
    texliveFull
    hunspell
    hunspellDicts.nl_NL
    hunspellDicts.en_GB-ise
    moondeck-buddy
  ];

  home.persistence = {
    "/persist/".directories = [ ".local/share/Anki2" ];
  };

  # autostart moondeck
  xdg.autostart.enable = true;
  xdg.autostart.entries = [
    "${pkgs.moondeck-buddy}/share/applications/MoonDeckBuddy.desktop"
  ];

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      workspace = "1";
      primary = true;
      position = "1024x0";
      refreshRate = 180;
      vrr = 1;
      cm = "hdredid";
      sdrbrightness = 2;
      sdrsaturation = 1;
      bitdepth = 10;
    }
    {
      name = "HDMI-A-1";
      width = 1024;
      height = 600;
      position = "0x0";
      workspace = "2";
    }
  ];
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
