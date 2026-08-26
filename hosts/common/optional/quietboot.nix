{
  pkgs,
  config,
  lib,
  ...
}:
{
  console = {
    useXkbConfig = true;
    earlySetup = false;
  };

  boot = {
    plymouth = {
      enable = true;
    };
    loader.timeout = 0;
    kernelParams = [
      "video=efifb:nobgrt"
      "fbcon=nodefer"
      "nobgrt"
      "bgrt_disable"
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
  };
}
