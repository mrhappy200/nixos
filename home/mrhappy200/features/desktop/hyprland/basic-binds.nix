{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];

    bind = let
      workspaces = [
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "F1"
        "F2"
        "F3"
        "F4"
        "F5"
        "F6"
        "F7"
        "F8"
        "F9"
        "F10"
        "F11"
        "F12"
      ];
      # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
      directions = rec {
        left = "l";
        right = "r";
        up = "u";
        down = "d";
        h = left;
        l = right;
        k = up;
        j = down;
      };
    in
      [
        "SUPERSHIFT,q,killactive"
        "SUPERSHIFT,e,exit"

        "SUPER,f,fullscreen,2"
        "SUPERSHIFT,f,fullscreen,0"
        "SUPERSHIFT,space,togglefloating"

        "SUPER,g,togglegroup"
        "SUPER,t,lockactivegroup,toggle"
        "SUPER,tab,changegroupactive,f"
        "SUPERSHIFT,tab,changegroupactive,b"

        "SUPER,apostrophe,workspace,previous"

        "SUPER,u,togglespecialworkspace"
        "SUPERSHIFT,u,movetoworkspacesilent,special"
        "SUPER,i,pseudo"
      ]
      ++
      # Change workspace
      (map
        (
          n: "SUPER,${n},workspace,name:${n}"
        )
        workspaces)
      ++
      # Move window to workspace
      (map
        (
          n: "SUPERSHIFT,${n},movetoworkspacesilent,name:${n}"
        )
        workspaces)
      ++
      # Move focus
      (lib.mapAttrsToList
        (
          key: direction: "SUPER,${key},movefocus,${direction}"
        )
        directions)
      ++
      # Swap windows
      (lib.mapAttrsToList
        (
          key: direction: "SUPERSHIFT,${key},swapwindow,${direction}"
        )
        directions)
      ++
      # Move windows
      (lib.mapAttrsToList
        (
          key: direction: "SUPERCONTROL,${key},movewindoworgroup,${direction}"
        )
        directions)
      ++
      # Move monitor focus
      (lib.mapAttrsToList
        (
          key: direction: "SUPERALT,${key},focusmonitor,${direction}"
        )
        directions)
      ++
      # Move workspace to other monitor
      (lib.mapAttrsToList
        (
          key: direction: "SUPERALTSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
        )
        directions);
  };
}
