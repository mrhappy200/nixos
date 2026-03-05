{ pkgs, ... }:
{
  security.polkit = {
    enable = true;
  };
  systemd = {
    user.services.hyprpolkitagent = {
      description = "Hyprland Polkit Authentication Agent";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Slice = "session.slice";
        TimeoutStopSec = "5sec";
        Restart = "on-failure";
      };
    };
  };
}
