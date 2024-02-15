{ lib, inputs, pkgs, config, ... }:

{
  programs.foot.enable = true;
  programs.foot.server.enable = true;
  programs.foot.settings = {
    main = {
      term = "foot";

      font = "Fira Code Nerd Font Mono:size=9";
    };
  };
}
