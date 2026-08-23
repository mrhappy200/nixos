{ ... }:
{
  security.pam.howdy.enable = true;
  services = {
    howdy = {
      enable = true;
      control = "required";
      settings = {
        core = {
          abort_if_ssh = true;
          device_path = "/dev/video2"; # Explicitly set based on your logs
        };
        video.timeout = 2;
      };
    };
    linux-enable-ir-emitter = {
      enable = true;
    };
  };
}
