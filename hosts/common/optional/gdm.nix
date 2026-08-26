{ ... }: {
  services.seatd.enable = true;
  services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";
    gdm = {
      enable = true;
    };
  };
}
