{ ... }:
let
in
{

  wayland.windowManager.hyprland = {
    systemd.enable = false;
  };
}

#uwsm app -- "$(D=$(wofi --show drun --define=drun-print_desktop_file=true); case "$D" in *'.desktop '*) echo "${D%.desktop *}.desktop:${D#*.desktop }";; *) echo "$D";; esac)"
