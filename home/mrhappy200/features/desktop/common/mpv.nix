{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = [
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.visualizer
      pkgs.mpvScripts.thumbfast
      pkgs.mpvScripts.mpris
    ];
  };
}
