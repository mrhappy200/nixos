{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
let
  hypr-dynamic-cursors =
    inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors;
in
{
  home.pointerCursor = {
    enable = true;
    package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
    name = "rose-pine-hyprcursor";
    gtk.enable = true;
    hyprcursor.enable = true;
    x11.enable = true;
  };
  wayland.windowManager.hyprland = {
    plugins = [ hypr-dynamic-cursors ];
    settings = {
      config.plugin.dynamic_cursors = {
        enabled = true;
        mode = "rotate";
        threshold = 2;

        rotate = {
          length = 20;
          offset = 0.0;
        };

        tilt = {
          limit = 5000;
          activation = "negative_quadratic";
          window = 100;
          full = 60;
        };

        stretch = {
          limit = 3000;
          activation = "quadratic";
          window = 100;
        };

        shake = {
          enabled = true;
          threshold = 6.0;
          base = 4.0;
          speed = 4.0;
          influence = 0.0;
          limit = 0.0;
          timeout = 2000;
          effects = false;
          ipc = false;
        };

        hyprcursor = {
          nearest = 1;
          enabled = true;
          resolution = -1;
          fallback = "clientside";
        };
      };
    };
  };
}
