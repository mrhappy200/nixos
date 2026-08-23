{ ... }: {
  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan Trackpoint";
    drift_time = 100;
    emulateWheel = true;
    press_to_select = true;
  };
}
