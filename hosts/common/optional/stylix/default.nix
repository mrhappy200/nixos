{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom-stylix;

  wallpaper-randomness = pkgs.runCommand "wallpaper-randomness.txt" { } ''
    echo ${cfg.cachebuster}
    printf "%X\n" $(shuf -i 8-15 -n 1) > $out
  '';
  wallpaper-svg = pkgs.runCommand "wallpaper.svg" { } ''
    echo ${cfg.cachebuster}
    BACKGROUND=$(${lib.getExe pkgs.yq} -r .palette.base00 ${cfg.theme})
    FOREGROUND=$(${lib.getExe pkgs.yq} -r .palette.base0$(cat ${wallpaper-randomness}) ${cfg.theme})
    echo $BACKGROUND
    echo $FOREGROUND
    cat ${cfg.svgTemplate} | sed "s/#REPLACEME-background/$BACKGROUND/g" | sed "s/#REPLACEME-foreground/$FOREGROUND/g" > $out
  '';
  wallpaper = pkgs.runCommand "wallpaper.png" { } ''
    echo ${cfg.cachebuster}
    ${lib.getExe pkgs.inkscape} -w ${toString cfg.width} -h ${toString cfg.height} ${wallpaper-svg} -o $out
  '';
in
{
  options.custom-stylix = {
    enable = lib.mkEnableOption "custom SVG wallpaper with stylix theming";

    theme = lib.mkOption {
      type = lib.types.path;
      default = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      example = lib.literalExpression ''"''${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml"'';
      description = "Path to a base16 YAML theme file used for wallpaper colours.";
    };

    svgTemplate = lib.mkOption {
      type = lib.types.path;
      default = ./BenBulben.svg.template;
      description = "Path to the SVG template file. Must contain #REPLACEME-background and #REPLACEME-foreground placeholders.";
    };

    cachebuster = lib.mkOption {
      type = lib.types.str;
      default = "8";
      description = "Increment this string to force the wallpaper derivations to rebuild.";
    };

    width = lib.mkOption {
      type = lib.types.int;
      default = 2560;
      description = "Output wallpaper width in pixels.";
    };

    height = lib.mkOption {
      type = lib.types.int;
      default = 1440;
      description = "Output wallpaper height in pixels.";
    };

    # Read-only outputs, useful for other modules consuming the generated files
    randomColourPath = lib.mkOption {
      type = lib.types.path;
      default = wallpaper-randomness;
      readOnly = true;
      description = "Path to the file containing the random base-number used for the wallpaper foreground colour.";
    };

    svgWallpaper = lib.mkOption {
      type = lib.types.path;
      default = wallpaper-svg;
      readOnly = true;
      description = "Path to the generated SVG wallpaper.";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = cfg.theme;
      image = wallpaper;
    };
  };
}
