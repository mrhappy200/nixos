{pkgs, ...}: let
in {
  programs.tofi = {
    enable = true;
    settings = {
      font = "${pkgs.ibm-plex}/share/fonts/opentype/IBMPlexSerif-Regular.otf";
      anchor = "top";
      width = "100%";
      height = 30;
      horizontal = true;
      font-size = 14;
      prompt-text = " run: ";
      outline-width = 0;
      border-width = 0;
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
      hint-font = false;
      ascii-input = false;
      late-keyboard-init = true;
      num-results = 10;
      hide-cursor = true;
      matching-algorithm = "fuzzy";
      auto-accept-single = true;
    };
  };
}
