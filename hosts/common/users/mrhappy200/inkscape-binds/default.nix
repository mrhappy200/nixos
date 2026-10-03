{ lib, pkgs, ... }:
let
  user = "mrhappy200";

  # Run `wl-paste --list-types` after copying an object in Inkscape.
  # If this target is absent but `image/svg+xml` is present, use that instead.
  inkscapeSvgMime = "image/x-inkscape-svg";

  userrun =
    command:
    lib.removeSuffix "\n" (
      lib.strings.concatStrings [
        "systemd-run --machine=${user}@.host --user --pipe --wait"
        " --unit inkscape-binds --collect -- /bin/sh -c ${lib.escapeShellArg command}"
      ]
    );

  open-editor = pkgs.writeShellScriptBin "open-editor" ''
        #!/usr/bin/env bash
        set -euo pipefail

        compile_latex="$1"
        fontsize=10
        font="monospace"

        tmpfile=$(${pkgs.coreutils}/bin/mktemp --suffix=-inkscape-editor.tex)
        printf '$$' > "$tmpfile"
        ${pkgs.emacs}/bin/emacsclient -c "$tmpfile"

        latex=$(<"$tmpfile")
        rm -f "$tmpfile"

        [[ "$latex" == '$$' ]] && exit 0

        if [[ "$compile_latex" == "true" ]]; then
          workdir=$(${pkgs.coreutils}/bin/mktemp -d)
          texfile="$workdir/input.tex"
          pdffile="$workdir/input.pdf"
          svgfile="$workdir/input.svg"

          cat > "$texfile" <<'LATEX_DOC'
    \documentclass[12pt,border=12pt]{standalone}
    \usepackage[utf8]{inputenc}
    \usepackage[T1]{fontenc}
    \usepackage{textcomp}
    \usepackage{amsmath,amssymb}
    \newcommand{\R}{\mathbb R}
    \begin{document}
    LATEX_DOC

          printf '%s' "$latex" >> "$texfile"
          printf '\n\\end{document}\n' >> "$texfile"

          ${pkgs.texlive.combined.scheme-basic}/bin/pdflatex \
            -interaction=nonstopmode \
            -output-directory "$workdir" \
            "$texfile" \
            > /dev/null 2>&1

          ${pkgs.pdf2svg}/bin/pdf2svg "$pdffile" "$svgfile"

          ${pkgs.wl-clipboard}/bin/wl-copy \
            --type ${inkscapeSvgMime} \
            < "$svgfile"

          rm -rf "$workdir"

          # Ctrl+V: paste SVG object.
          ${lib.getExe pkgs.ydotool} key 29:1 47:1 47:0 29:0
        else
          svg=$(cat <<SVGEOF
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg
      xmlns="http://www.w3.org/2000/svg"
      xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
      xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">
      <text
        style="font-size:''${fontsize}px;font-family:''${font};-inkscape-font-specification:''${font}, Normal;fill:#000000;fill-opacity:1;stroke:none"
        xml:space="preserve"><tspan sodipodi:role="line">''${latex}</tspan></text>
    </svg>
    SVGEOF
    )

          printf '%s' "$svg" | ${pkgs.wl-clipboard}/bin/wl-copy \
            --type ${inkscapeSvgMime}

          # Ctrl+V: paste SVG object.
          ${lib.getExe pkgs.ydotool} key 29:1 47:1 47:0 29:0
        fi

        ${lib.getExe pkgs.ydotool} key 1:1 1:0
  '';

  paste-style =
    pkgs.writers.writePython3Bin "paste-style"
      {
        libraries = [ ];
        flakeIgnore = [
          "E226"
          "E501"
          "E701"
          "E221"
          "E272"
          "W504"
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

        if 'g' in combination:
            w = thick_width
            style['stroke-width'] = w

        if 'h' in combination:
            w = very_thick_width
            style['stroke-width'] = w

        if 'a' in combination:
            style['marker-end'] = f'url(#marker-arrow-{w})'

        if 'x' in combination:
            style['marker-start'] = f'url(#marker-arrow-{w})'
            style['marker-end'] = f'url(#marker-arrow-{w})'

        if 'd' in combination:
            style['stroke-dasharray'] = f'{w},{2 * pt}'

        if 'e' in combination:
            style['stroke-dasharray'] = f'{3 * pt},{3 * pt}'

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
        else:
            style['fill'] = 'none'
            style['fill-opacity'] = 1

        if style.get('fill') == 'none' and style.get('stroke') == 'none':
            sys.exit(0)

        svg = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">"""

        needs_marker = (
            ('marker-end' in style and style['marker-end'] != 'none') or
            ('marker-start' in style and style['marker-start'] != 'none')
        )

        if needs_marker:
            scale = (2.40 * w + 3.87) / (4.5 * w)
            svg += f"""
              <defs id="marker-defs">
                <marker id="marker-arrow-{w}"
                        orient="auto-start-reverse"
                        refY="0" refX="0"
                        markerHeight="1.690" markerWidth="0.911">
                  <g transform="scale({scale})">
                    <path
                      d="M -1.55415,2.0722 C -1.42464,1.29512 0,0.1295 0.38852,0 0,-0.1295 -1.42464,-1.29512 -1.55415,-2.0722"
                      style="fill:none;stroke:#000000;stroke-width:0.6;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1" />
                  </g>
                </marker>
              </defs>"""

        svg += f"""  <inkscape:clipboard style="{style_string}" />
        </svg>
        """

        subprocess.run(
            ['wl-copy', '--type', 'image/x-inkscape-svg'],
            input=svg.encode('utf-8'),
            check=True,
        )

        # Crucial: without --type, wl-copy publishes this as text/plain.
        subprocess.run(
            ['wl-copy', '--type', '${inkscapeSvgMime}'],
            input=svg.encode('utf-8'),
            check=True,
        )

        # Ctrl+Shift+V: paste style.
        subprocess.run(
            ['ydotool', 'key', '29:1', '42:1', '47:1', '47:0', '42:0', '29:0'],
            check=True,
        )
      '';

  save-style-or-object = pkgs.writeShellScriptBin "inkscape-save-style-or-object" ''
    #!/usr/bin/env bash
    set -euo pipefail

    type_="$1"
    dir="$HOME/.config/inkscape-shortcut-manager/${"\${type_}"}s"
    mkdir -p "$dir"

    ${lib.getExe pkgs.ydotool} key 29:1 46:1 46:0 29:0
    sleep 0.2

    svg=$(
      ${pkgs.wl-clipboard}/bin/wl-paste \
        --type ${inkscapeSvgMime} \
        2>/dev/null || true
    )

    if [[ "$svg" != *"svg"* ]]; then
      ${pkgs.libnotify}/bin/notify-send \
        "inkscape-shortcut-manager" \
        "Clipboard does not contain Inkscape SVG – nothing saved."
      exit 0
    fi

    name=$(
      printf "" |
        ${pkgs.rofi}/bin/rofi -dmenu -p "Save $type_ as" ||
        true
    )

    [[ -z "$name" ]] && exit 0

    outfile="$dir/$name.svg"

    if [[ -f "$outfile" ]]; then
      answer=$(
        printf 'y\nn' |
          ${pkgs.rofi}/bin/rofi -dmenu -p "Overwrite $name?" ||
          true
      )
      [[ "$answer" != "y" ]] && exit 0
    fi

    printf '%s' "$svg" > "$outfile"

    ${pkgs.libnotify}/bin/notify-send \
      "inkscape-shortcut-manager" \
      "Saved $type_ as '$name'."
  '';

  apply-named = pkgs.writeShellScriptBin "inkscape-apply-named" ''
    #!/usr/bin/env bash
    set -euo pipefail

    type_="$1"
    dir="$HOME/.config/inkscape-shortcut-manager/${"\${type_}"}s"
    mkdir -p "$dir"

    names=$(ls "$dir" 2>/dev/null | ${pkgs.gnused}/bin/sed 's/\.svg$//' || true)
    [[ -z "$names" ]] && exit 0

    name=$(
      printf '%s\n' $names |
        ${pkgs.rofi}/bin/rofi -dmenu -p "Apply $type_" ||
        true
    )

    [[ -z "$name" ]] && exit 0

    file="$dir/$name.svg"
    [[ ! -f "$file" ]] && exit 0

    ${pkgs.wl-clipboard}/bin/wl-copy \
      --type ${inkscapeSvgMime} \
      < "$file"

    if [[ "$type_" == "style" ]]; then
      ${lib.getExe pkgs.ydotool} key 29:1 42:1 47:1 47:0 42:0 29:0
    else
      ${lib.getExe pkgs.ydotool} key 29:1 47:1 47:0 29:0
    fi
  '';

  styleChords = [
    # ── No fill: stroke columns ──────────────────────────────────────────────
    # Plain thin solid stroke is unavailable because `s` alone opens
    # named-style selection.
    "s+d" # Thin dashed stroke.
    "s+e" # Thin loosely-dashed stroke.
    "s+g" # Thick solid stroke.
    "s+g+d" # Thick dashed stroke.
    "s+g+e" # Thick loosely-dashed stroke.
    "s+h" # Very-thick solid stroke.
    "s+h+d" # Very-thick dashed stroke.
    "s+h+e" # Very-thick loosely-dashed stroke.

    # ── Gray fill (F) ────────────────────────────────────────────────────────
    "f+s" # Gray fill, thin solid outline.
    "f+d" # Gray fill, thin dashed outline.
    "f+e" # Gray fill, thin loosely-dashed outline.
    "f+g" # Gray fill, thick solid outline.
    "f+g+d" # Gray fill, thick dashed outline.
    "f+g+e" # Gray fill, thick loosely-dashed outline.
    "f+h" # Gray fill, very-thick solid outline.
    "f+h+d" # Gray fill, very-thick dashed outline.
    "f+h+e" # Gray fill, very-thick loosely-dashed outline.

    # ── White fill (W) ───────────────────────────────────────────────────────
    "w+s" # White fill, thin solid outline.
    "w+d" # White fill, thin dashed outline.
    "w+e" # White fill, thin loosely-dashed outline.
    "w+g" # White fill, thick solid outline.
    "w+g+d" # White fill, thick dashed outline.
    "w+g+e" # White fill, thick loosely-dashed outline.
    "w+h" # White fill, very-thick solid outline.
    "w+h+d" # White fill, very-thick dashed outline.
    "w+h+e" # White fill, very-thick loosely-dashed outline.

    # ── Black fill (B) ───────────────────────────────────────────────────────
    "b+s" # Black fill, thin solid outline.
    "b+d" # Black fill, thin dashed outline.
    "b+e" # Black fill, thin loosely-dashed outline.
    "b+g" # Black fill, thick solid outline.
    "b+g+d" # Black fill, thick dashed outline.
    "b+g+e" # Black fill, thick loosely-dashed outline.
    "b+h" # Black fill, very-thick solid outline.
    "b+h+d" # Black fill, very-thick dashed outline.
    "b+h+e" # Black fill, very-thick loosely-dashed outline.

    # ── Single-headed arrow (A) ──────────────────────────────────────────────
    "a+s" # Thin solid arrow.
    "a+d" # Thin dashed arrow.
    "a+e" # Thin loosely-dashed arrow.
    "a+g" # Thick solid arrow.
    "a+g+d" # Thick dashed arrow.
    "a+g+e" # Thick loosely-dashed arrow.
    "a+h" # Very-thick solid arrow.
    "a+h+d" # Very-thick dashed arrow.
    "a+h+e" # Very-thick loosely-dashed arrow.

    # ── Double-headed arrow (X) ──────────────────────────────────────────────
    "x+s" # Thin solid double arrow.
    "x+d" # Thin dashed double arrow.
    "x+e" # Thin loosely-dashed double arrow.
    "x+g" # Thick solid double arrow.
    "x+g+d" # Thick dashed double arrow.
    "x+g+e" # Thick loosely-dashed double arrow.
    "x+h" # Very-thick solid double arrow.
    "x+h+d" # Very-thick dashed double arrow.
    "x+h+e" # Very-thick loosely-dashed double arrow.

    # ── Fill only, no stroke ──────────────────────────────────────────────────
    # `b` overrides `f`; `w` overrides both b and f.
    "f+b" # Opaque black fill, no stroke.
    "f+w" # Opaque white fill, no stroke.
  ];

  styleChordBindings = builtins.listToAttrs (
    map (chord: {
      name = chord;
      value = "command(${userrun "${paste-style}/bin/paste-style ${lib.replaceStrings [ "+" ] [ " " ] chord}"})";
    }) styleChords
  );

in
{
  environment.systemPackages = with pkgs; [
    ydotool
    wl-clipboard
    rofi
    libnotify
    emacs
    pdf2svg
    (texlive.combined.scheme-basic)
    open-editor
    paste-style
    save-style-or-object
    apply-named
  ];

  services.keyd = {
    enable = true;

    keyboards.default.settings = {
      main = {
        favorites = "toggle(inkscape)";
        pause = "toggle(inkscape)";
      };

      inkscape = styleChordBindings // {
        t = "command(${userrun "${open-editor}/bin/open-editor false"})";
        s = "command(${userrun "${apply-named}/bin/inkscape-apply-named style"})";
        a = "command(${userrun "${apply-named}/bin/inkscape-apply-named object"})";

        w = "p";
        x = "S-5";
        f = "b";
        z = "C-z";
      };

      # Active only while both the `inkscape` toggle layer and physical Shift
      # layer are active.
      "inkscape+shift" = {
        t = "command(${userrun "${open-editor}/bin/open-editor true"})";
        s = "command(${userrun "${save-style-or-object}/bin/inkscape-save-style-or-object style"})";
        a = "command(${userrun "${save-style-or-object}/bin/inkscape-save-style-or-object object"})";
        z = "delete";
      };

    };
  };
}
