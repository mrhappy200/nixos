{ pkgs, ... }:
let
in
{
  home.packages = [ pkgs.blender ];
  home.persistence = {
    "/persist/" = {
      directories = [ ".config/blender/" ];
    };
  };
}
