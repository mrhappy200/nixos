{
  lib,
  config,
  ...
}:
let
  lua = lib.generators.mkLuaInline;

  mkBind = keys: dispatcher: {
    _args = [
      keys
      (lua dispatcher)
    ];
  };
in
{
  wayland.windowManager.hyprland.settings.bind =
    let
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
      ];

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
      (mkBind "SUPER + mouse:272" "hl.dsp.window.drag()")
      (mkBind "SUPER + mouse:273" "hl.dsp.window.resize()")

      (mkBind "SUPER + SHIFT + q" "hl.dsp.window.close()")
      (mkBind "SUPER + SHIFT + e" "hl.dsp.exit()")

      (mkBind "SUPER + f" ''
        hl.dsp.window.fullscreen({
          action = "toggle",
          mode = "maximized",
        })
      '')
      (mkBind "SUPER + SHIFT + f" ''
        hl.dsp.window.fullscreen({
          action = "toggle",
          mode = "fullscreen",
        })
      '')
      (mkBind "SUPER + SHIFT + space" "hl.dsp.window.float()")

      (mkBind "SUPER + g" "hl.dsp.group.toggle()")
      (mkBind "SUPER + t" ''hl.dsp.group.lock_active({ action = "toggle" })'')
      (mkBind "SUPER + tab" "hl.dsp.group.next()")
      (mkBind "SUPER + SHIFT + tab" "hl.dsp.group.prev()")

      (mkBind "SUPER + apostrophe" ''hl.dsp.focus({ workspace = "previous" })'')
      (mkBind "SUPER + SHIFT + apostrophe" ''hl.dsp.focus({ workspace = "next" })'')
      (mkBind "SUPER + dead_grave" ''hl.dsp.focus({ workspace = "previous" })'')
      (mkBind "SUPER + SHIFT + dead_grave" ''hl.dsp.focus({ workspace = "next" })'')

      (mkBind "SUPER + u" ''hl.dsp.workspace.toggle_special("default")'')
      (mkBind "SUPER + SHIFT + u" ''hl.dsp.window.move({ workspace = "special:default" })'')
      (mkBind "SUPER + m" ''hl.dsp.workspace.toggle_special("music")'')
      (mkBind "SUPER + SHIFT + m" ''hl.dsp.window.move({ workspace = "special:music" })'')

      # Bindings for a scrolling layout
      (mkBind "SUPER + SHIFT + comma" ''hl.dsp.layout("swapcol l")'')
      (mkBind "SUPER + SHIFT + period" ''hl.dsp.layout("swapcol r")'')
                       
      (mkBind "SUPER + SHIFT + minus" ''hl.dsp.layout("colresize -0.1")'')
      (mkBind "SUPER + SHIFT + equal" ''hl.dsp.layout("colresize +0.1")'')
                      
      (mkBind "SUPER + SHIFT + RETURN" ''hl.dsp.layout("promote")'')

      (mkBind "SUPER + i" "hl.dsp.window.pseudo()")
      (mkBind "SUPER + y" "hl.dsp.window.toggle_swallow()")
      (mkBind "SUPER + p" "hl.dsp.window.pin()")
    ]
    ++ map (n: mkBind "SUPER + ${n}" ''hl.dsp.focus({ workspace = "${n}" })'') workspaces
    ++ map (
      n: mkBind "SUPER + SHIFT + ${n}" ''hl.dsp.window.move({ workspace = "${n}", follow = false })''
    ) workspaces
    ++ lib.mapAttrsToList (
      key: direction: mkBind "SUPER + ${key}" ''hl.dsp.focus({ direction = "${direction}" })''
    ) directions
    ++ lib.mapAttrsToList (
      key: direction:
      mkBind "SUPER + SHIFT + ${key}" ''hl.dsp.window.swap({ direction = "${direction}" })''
    ) directions
    ++ lib.mapAttrsToList (
      key: direction:
      mkBind "SUPER + CTRL + ${key}" ''hl.dsp.window.move({ direction = "${direction}" })''
    ) directions
    ++ lib.mapAttrsToList (
      key: direction: mkBind "SUPER + ALT + ${key}" ''hl.dsp.focus({ monitor = "${direction}" })''
    ) directions
    ++ lib.mapAttrsToList (
      key: direction:
      mkBind "SUPER + ALT + SHIFT + ${key}" ''hl.dsp.workspace.move({ monitor = "${direction}" })''
    ) directions;
}
