{ pkgs, inputs, ... }:
let
in
{
  home.packages = with pkgs; [
    material-symbols
    inter
    fira-code
    inotify-tools
    cava
    wl-clipboard
    cliphist
    ddcutil
    libsForQt5.qt5ct
    kdePackages.qt6ct
    matugen
    inputs.dgop.packages.${pkgs.system}.dgop
    brightnessctl
    app2unit
    cava
    networkmanager
    lm_sensors
    aubio
    pipewire
    glibc
    kdePackages.qtdeclarative
    libgcc
    nerd-fonts.caskaydia-cove
    grim
    swappy
    libqalculate
  ];
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.system}.default;
    activeConfig = "caelestia";
    configs = {
      dank = "${inputs.dankMaterialShell}";
      iimpulse = "${inputs.illogical-impulse}/.config/quickshell/ii";
    };
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
  };
}
