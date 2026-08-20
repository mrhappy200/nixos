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
      "plugin:dynamic-cursors" = {
        enabled = true;
        mode = "rotate";
        shake = {
          enabled = true;
        };
      };
    };
  };
}
