{
  pkgs,
  inputs,
  ...
}:
let
in
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus ];
    settings = {
      "plugin:hyprfocus" = {
        enabled = true;
        mode = "slide";
        slide_strength = 0.3;
        #bounce_strength = 0.997;
      };
    };
  };
}
