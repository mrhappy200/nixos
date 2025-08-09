{...}: let
  port = 44100;
in {
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire = {
        "10-simple-protocol" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-protocol-simple";
              "args" = {
                "capture" = true;
                "audio.rate" = port;
                "audio.format" = "S16LE";
                "audio.channels" = 2;
                "audio.position" = ["FL" "FR"];
                "server.address" = [
                  "tcp:4711"
                ];
              };
            }
          ];
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [port];
  };
}
