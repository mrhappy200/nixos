#{ lib, pkgs, ... }:
#let
#  user = "mrhappy200";
#  userrun =
#    command:
#    lib.removeSuffix "\n" ''
#      systemd-run --unit inkscape-binds --uid ${user} sh -c ${command}
#    '';
#  open-editor = pkgs.writeShellScriptBin "open-editor" ''
#      #!/usr/bin/env bash
#
#      # Config
#      fontsize=10
#      font="monospace"
#
#
#      tmpfile=$(mktemp --suffix=-inkscape-editor.tex)
#      echo "Editing: $tmpfile"
#      emacsclient -c $tmpfile
#
#      latex=$(<$tmpfile)
#
#      echo "LaTeX: $latex"
#
#      IFS=''' read
#    - r
#    - d '''
#       svg <<EOF
#      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
#          <svg>
#            <text
#               style="font-size:''${fontsize}px; font-family:''${font}';-inkscape-font-specification:''${font}, Normal';fill:#000000;fill-opacity:1;stroke:none;"
#               xml:space="preserve"><tspan sodipodi:role="line" >''${latex}</tspan></text>
#          </svg>
#      EOF
#
#      echo "SVG: $svg"
#
#      printf '%s' "$svg" | wl-copy
#      # CTRL:1 V:1 V:0 CTRL:0
#      ydotool key 29:1 47:1 47:0 29:0
#  '';
#
#in
#{
#  services.keyd = {
#    keyboards.default.settings = {
#      main = {
#        pause = "toggle(inkscape)";
#      };
#      inkscape = {
#        t = "command(${userrun ("${open-editor}/bin/open-editor")})";
#      };
#    };
#  };
#}

{ lib, pkgs, ... }:
let
  user = "mrhappy200";
  userrun =
    command:
    lib.removeSuffix "\n" ''
      systemd-run --unit inkscape-binds --uid ${user} sh -c ${command}
    '';

  open-editor = pkgs.writeShellScriptBin "open-editor" ''
    #!/usr/bin/env bash
    fontsize=10
    font="monospace"
    prerender=$1
    tmpfile=$(${lib.getExe pkgs.mktemp}/bin/mktemp --suffix=-inkscape-editor.tex)
    ${pkgs.emacs}/bin/emacsclient -c $tmpfile
    latex=$(<$tmpfile)
    IFS=''' read -r -d ''' svg <<EOF
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg>
      <text style="font-size:''${fontsize}px; font-family:''${font}';-inkscape-font-specification:''${font}, Normal';fill:#000000;fill-opacity:1;stroke:none;" xml:space="preserve"><tspan sodipodi:role="line">''${latex}</tspan></text>
    </svg>
    EOF
    printf '%s' "$svg" | ${pkgs.wl-clipboard}/bin/wl-copy
    ${lib.getExe pkgs.ydotool} key 29:1 47:1 47:0 29:0
  '';

  paste-style =
    pkgs.writers.writePython3Bin "paste-style"
      {
        libraries = [
        ];
        flakeIgnore = [
          "E226"
          "E501"
          "E701"
        ];
      }
      ''
        import sys
        import subprocess

        combination = set(sys.argv[1:])
        pt = 1.327
        w = 0.4 * pt
        thick_width = 0.8 * pt
        very_thick_width = 1.2 * pt

        style = {'stroke-opacity': 1}

        if {'s', 'a', 'd', 'g', 'h', 'x', 'e'} & combination:
            style['stroke'] = 'black'
            style['stroke-width'] = w
            style['marker-end'] = 'none'
            style['marker-start'] = 'none'
            style['stroke-dasharray'] = 'none'
        else:
            style['stroke'] = 'none'

        if 'g' in combination: style['stroke-width'] = thick_width
        if 'h' in combination: style['stroke-width'] = very_thick_width
        if 'a' in combination: style['marker-end'] = f'url(#marker-arrow-{w})'
        if 'x' in combination:
            style['marker-start'] = f'url(#marker-arrow-{w})'
            style['marker-end'] = f'url(#marker-arrow-{w})'
        if 'd' in combination: style['stroke-dasharray'] = f'{w},{2*pt}'
        if 'e' in combination: style['stroke-dasharray'] = f'{3*pt},{3*pt}'

        if 'f' in combination:
            style['fill'] = 'black'
            style['fill-opacity'] = 0.12
        if 'b' in combination:
            style['fill'] = 'black'
            style['fill-opacity'] = 1
        if 'w' in combination:
            style['fill'] = 'white'
            style['fill-opacity'] = 1

        if {'f', 'b', 'w'} & combination:
            style['marker-end'] = 'none'
            style['marker-start'] = 'none'
        elif not ({'f', 'b', 'w'} & combination):
            style['fill'] = 'none'
            style['fill-opacity'] = 1

        if style['fill'] == 'none' and style['stroke'] == 'none':
            sys.exit(0)

        svg = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n<svg>'
        if ('marker-end' in style and style['marker-end'] != 'none') or ('marker-start' in style and style['marker-start'] != 'none'):
            svg += f"""
                <defs id="marker-defs">
                <marker id="marker-arrow-{w}" orient="auto-start-reverse" refY="0" refX="0" markerHeight="1.690" markerWidth="0.911">
                  <g transform="scale({(2.40 * w + 3.87)/(4.5*w)})">
                    <path d="M -1.55415,2.0722 C -1.42464,1.29512 0,0.1295 0.38852,0 0,-0.1295 -1.42464,-1.29512 -1.55415,-2.0722" style="fill:none;stroke:#000000;stroke-width:0.6;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1" />
                  </g>
                </marker>
                </defs>
            """

        style_string = ';'.join(f'{k}: {v}' for k, v in sorted(style.items()))
        svg += f'<inkscape:clipboard style="{style_string}" /></svg>'

        subprocess.run(['wl-copy'], input=svg.encode('utf-8'))
        # CTRL:1 SHIFT:1 V:1 V:0 SHIFT:0 CTRL:0
        subprocess.run(['ydotool', 'key', '29:1', '42:1', '47:1', '47:0', '42:0', '29:0'])
      '';

in
{
  services.keyd = {
    keyboards.default.settings = {
      main = {
        pause = "toggle(inkscape)";
      };
      inkscape = {
        # Vim mode
        t = "command(${userrun "${open-editor}/bin/open-editor false"})";
        # Vim mode prerendered
        "S-t" = "command(${userrun "${open-editor}/bin/open-editor true"})";

        # Internal state modes. If these map to UI states, replace the mock commands with actual ydotool mappings.
        a = "command(${userrun "notify-send 'Object Mode Active'"})";
        "S-a" = "command(${userrun "notify-send 'Save Object Mode'"})";
        s = "command(${userrun "notify-send 'Style Mode Active'"})";
        "S-s" = "command(${userrun "notify-send 'Save Style Mode'"})";

        # Single key shortcuts
        w = "p"; # Pencil
        x = "S-5"; # Snap (%)
        f = "b"; # Bezier
        z = "C-z"; # Undo
        "S-z" = "delete"; # Delete
        "`" = "t"; # Disabled mode / text mode

        # Explicit chords for paste_style (Add the combinations you use most)
        "s+f" = "command(${userrun "${paste-style}/bin/paste-style s f"})";
        "s+a" = "command(${userrun "${paste-style}/bin/paste-style s a"})";
        "s+d" = "command(${userrun "${paste-style}/bin/paste-style s d"})";
        "s+f+w" = "command(${userrun "${paste-style}/bin/paste-style s f w"})";
      };
    };
  };
}
