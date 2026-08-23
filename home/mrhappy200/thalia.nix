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
    ./features/desktop/hyprland
    ./features/nvim
    ./features/emacs
    ./features/desktop/common/flatpak.nix
    ./features/desktop/common/lanmouse.nix
    ./features/desktop/wireless
    ./features/desktop/vnc.nix
    ./features/productivity
    ./features/pass
    ./features/games
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.packages = with pkgs; [
    graphviz
    hunspell
    hunspellDicts.nl_NL
    hunspellDicts.en_GB-ise
  ];

  home.persistence = {
    "/persist/".directories = [ ".local/share/Anki2" ];
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
      position = "0x0";
      refreshRate = 60;
      vrr = 1;
      cm = "hdredid";
      sdrbrightness = 2;
      sdrsaturation = 1;
      bitdepth = 10;
    }
  ];
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
