{
  pkgs,
  lib,
  config,
  ...
}:
let
  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  sway-kiosk =
    command:
    "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      xwayland disable
      input "type:touchpad" {
        tap enabled
      }
      exec 'XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0 ${command}; ${pkgs.sway}/bin/swaymsg exit'
    ''} &>/dev/null";
in
{
  users.extraUsers.greeter = {
    # For caching and such
    home = "/tmp/greeter-home";
    createHome = true;
  };

  services.seatd.enable = true;
  services.displayManager.enable = true;

  services.displayManager.regreet = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  #services.displayManager.noctalia-greeter = {
  #  enable = true;
  #  settings = {
  #    session = {
  #      default = "Hyprland (UWSM)";
  #    };
  #    user = {
  #      default = "mrhappy200";
  #    };
  #  };
  #};

}
