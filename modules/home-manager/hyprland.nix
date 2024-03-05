{ lib, inputs, pkgs, config, ... }:

{
  options = {
    wm.terminal = lib.mkOption {
      type = lib.types.path;
      default = pkgs.foot/bin/footclient;
    };
  };
  config = {
    home.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";

        bind =
          let
            terminal = "${pkgs.foot}/bin/footclient";
            launcher = "${pkgs.tofi}/bin/tofi-drun";
          in
          [
            ",F10, killactive,"
            "$mod, Return, exec, ${terminal}"
            ",F12, exec, ${terminal}"
            ",F11, exit,"
            "$mod, F, fullscreen,"
            "$mod SHIFT, D, exec , ${launcher}"
            "$mod SHIFT, F, togglefloating"
            "$mod, S, layoutmsg,swapwithmaster"
          ];
      };
    };
  };
}
