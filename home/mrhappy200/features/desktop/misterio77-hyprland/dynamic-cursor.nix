{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors;
in {
  wayland.windowManager.hyprland = {
    plugins = [hypr-dynamic-cursors];
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
