{ lib, pkgs, ... }:
let
  wallpaper-template = ./BenBulben.svg.template;
  #theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  cachebuster = "8";
  wallpaper-randomness = pkgs.runCommand "wallpaper-randomness.txt" { } ''
    echo ${cachebuster}
    printf "%X\n" $(shuf -i 8-15 -n 1) > $out
  '';
  wallpaper-svg = pkgs.runCommand "wallpaper.svg" { } ''
    echo ${cachebuster}
    BACKGROUND=$(${lib.getExe pkgs.yq} -r .palette.base00 ${theme})
    FOREGROUND=$(${lib.getExe pkgs.yq} -r .palette.base0$(cat ${wallpaper-randomness}) ${theme})
    echo $BACKGROUND
    echo $FOREGROUND
    cat ${wallpaper-template} | sed "s/#REPLACEME-background/$BACKGROUND/g" | sed "s/#REPLACEME-foreground/$FOREGROUND/g" > $out
  '';
  wallpaper = pkgs.runCommand "wallpaper.png" { } ''
    echo ${cachebuster}
    ${lib.getExe pkgs.inkscape} -w 2560 -h 1440 ${wallpaper-svg} -o $out
  '';
in
{
  options.stylix.randomColourPath = lib.mkOption {
    type = lib.types.path;
    default = wallpaper-randomness;
    description = "Path to file containing random basenumber used for wallpaper";
  };
  options.stylix.svgWallpaper = lib.mkOption {
    type = lib.types.path;
    default = wallpaper-svg;
    description = "Path to file containing svg variant of wallpaper";
  };
  config = {
    stylix = {
      enable = true;
      base16Scheme = theme; # image = ./BenBulben.png;
      image = wallpaper;
    };
  };
}
